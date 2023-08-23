module withinfinity::pet_system {
    use eps::world::{World, add_entity_in_world };
    use eps::entity::{create_entity, add_component };
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use withinfinity::pet_component::{new_pet, Pet};
    use eps::world;
    use components::name_component;
    use components::sex_component;
    use components::birth_time_component;
    use components::name_component::NameComponent;
    use eps::entity;
    use withinfinity::status_component;
    use components::birth_time_component::BirthTimeComponent;
    use components::sex_component::SexComponent;
    use sui::object::ID;

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) {
        let pet = new_pet(ctx);

        let entity = create_entity(ctx);
        let name_component = name_component::new_name(name);
        let sex_component = sex_component::new_sex(sex);
        let birth_component = birth_time_component::new_birth_time(clock);
        let status_component =  status_component::new_status(ctx, clock);

        add_component(&mut entity,name_component::get_component_id(),name_component);
        add_component(&mut entity,sex_component::get_component_id(),sex_component);
        add_component(&mut entity,birth_time_component::get_component_id(),birth_component);
        add_component(&mut entity,status_component::get_component_id(),status_component);

        add_entity_in_world(world, &pet, entity);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    public entry fun update_pet_name(world: &mut World, pet: &Pet, name: vector<u8>, _ctx: &mut TxContext) {
        let entity = world::get_mut_entity(world, pet);
        let name_component_id = name_component::get_component_id();
        let name_component = entity::get_mut_component<NameComponent>(entity, name_component_id);
        name_component::update_name(name_component,name);
    }

    // ============================================ View Functions ============================================
    public fun get_pet_basic_info(world: &World, pet_id: ID, clock: &Clock): (vector<u8>,bool,u64,u64) {
        let entity = world::get_entity(world, pet_id);
        let name_component_id = name_component::get_component_id();
        let name_component = entity::get_component<NameComponent>(entity, name_component_id);
        let sex_component_id = sex_component::get_component_id();
        let sex_component = entity::get_component<SexComponent>(entity, sex_component_id);
        let birth_time_component_id = birth_time_component::get_component_id();
        let birth_time_component = entity::get_component<BirthTimeComponent>(entity, birth_time_component_id);
        (
            name_component::get_name(name_component),
            sex_component::get_sex(sex_component),
            birth_time_component::get_birth_time(birth_time_component),
            birth_time_component::get_age_timestamp(birth_time_component, clock),
        )
    }
}




