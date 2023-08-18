module crypto_pet::login_system {
    use eps::world::{World, add_entity_in_world };
    use eps::entity::{create_entity, add_component };
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use crypto_pet::pet_component::{new_pet, Pet};
    use eps::world;
    use components::name_component;
    use components::sex_component;
    use components::birth_time_component;
    use components::name_component::NameComponent;
    use eps::entity;
    use crypto_pet::status_component;
    use crypto_pet::status_component::Status;
    use sui::table;
    use sui::clock;

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool,clock: &Clock, ctx: &mut TxContext) {
        let pet = new_pet(ctx);

        let entity = create_entity(ctx);
        let name_component = name_component::new_name(name);
        let sex_component = sex_component::new_sex(sex);
        let birth_component = birth_time_component::new_birth_time(clock);
        let status_component =  status_component::new_status(ctx);

        add_component(&mut entity,name_component);
        add_component(&mut entity,sex_component);
        add_component(&mut entity,birth_component);
        add_component(&mut entity,status_component);

        add_entity_in_world(world, &pet, entity);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    public entry fun update_pet_name(world: &mut World, pet: &mut Pet, name: vector<u8>, _ctx: &mut TxContext) {
        let entity = world::get_mut_entity(world, pet);
        let name_component_id = name_component::get_component_id();
        let name_component = entity::get_mut_component<NameComponent>(entity, name_component_id);
        name_component::update_name(name_component,name);
    }

    // ============================================ View Functions ============================================

    public fun get_pet_state(world: &mut World, pet: &Pet , clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let entity = world::get_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_component<Status>(entity, status_component_id);
        let state = status_component::get_status_state(status_component);
        let (hunger_level, cleanliness_level, mood_level, level) = status_component::get_status_level(status_component);
        if (state == b"offline") {
            return (state, hunger_level,cleanliness_level,mood_level,level)
        };

        let state_time_table = status_component::get_status_state_time(status_component);
        let state_time = table::borrow(state_time_table,state);
        let current_time = clock::timestamp_ms(clock);
        let consume_time =  current_time - *state_time / 60000u64;
        if (hunger_level > consume_time * 2) {
            hunger_level = hunger_level - consume_time * 2;
        } else {
            hunger_level = 0;
        };

        if (cleanliness_level > consume_time * 3) {
            cleanliness_level = cleanliness_level - consume_time * 3;
        }else {
            cleanliness_level = 0;
        };

        if (mood_level > consume_time * 1) {
            mood_level = mood_level - consume_time * 1;
        } else {
            mood_level = 0;
        };

        level = level + consume_time / 60u64;
        return (state, hunger_level,cleanliness_level,mood_level,level)
    }
}
