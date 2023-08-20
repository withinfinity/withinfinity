module crypto_pet::status_system {
    use eps::world::World;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use crypto_pet::pet_component::Pet;
    use eps::world;
    use eps::entity;
    use crypto_pet::status_component;
    use crypto_pet::status_component::Status;
    use sui::object::ID;
    use sui::object;
    use sui::table;
    use sui::clock;

    public entry fun login(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"online", clock)
    }

    public entry fun logout(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"offline", clock)
    }

    public entry fun clean(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"clean", clock)
    }

    fun update_state(world: &mut World, pet: &Pet, state: vector<u8>,  clock: &Clock) {
        let status_component_id = status_component::get_component_id();
        let (old_state,hunger_level,cleanliness_level,mood_level,level) = get_pet_state(world, object::id(pet), clock);
        assert!(state != old_state,0);
        let entity = world::get_mut_entity(world, pet);
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        status_component::set_status_state_time(status_component,b"clean",hunger_level,cleanliness_level,mood_level,level,clock);
    }

    public fun get_current_state_consume_time_ms(status: &Status,clock: &Clock) : u64 {
        let state_time_table = status_component::get_status_state_time(status);
        let state_time = table::borrow(state_time_table,status_component::get_status_state(status));
        let current_time = clock::timestamp_ms(clock);
        current_time - *state_time
    }

    public fun online_rule(status: &Status,clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let consume_time_ms = get_current_state_consume_time_ms(status, clock);
        let (hunger_level, cleanliness_level, mood_level, level) = status_component::get_status_level(status);
        let consume_time_m = consume_time_ms / 60000u64;
        if (hunger_level > consume_time_m * 2) {
            hunger_level = hunger_level - consume_time_m * 2;
        } else {
            hunger_level = 0;
        };

        if (cleanliness_level > consume_time_m * 3) {
            cleanliness_level = cleanliness_level - consume_time_m * 3;
        }else {
            cleanliness_level = 0;
        };

        if (mood_level > consume_time_m * 1) {
            mood_level = mood_level - consume_time_m * 1;
        } else {
            mood_level = 0;
        };

        level = level + consume_time_m / 60u64;
        return (status_component::get_status_state(status), hunger_level,cleanliness_level,mood_level,level)
    }

    public fun offline_rule(status: &Status) : (vector<u8>,u64,u64,u64,u64) {
        let (hunger_level, cleanliness_level, mood_level, level) = status_component::get_status_level(status);
        return (status_component::get_status_state(status), hunger_level,cleanliness_level,mood_level,level)
    }

    // ============================================ View Functions ============================================
    public fun get_pet_state(world: &mut World, pet_id: ID , clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let entity = world::get_entity(world, pet_id);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_component<Status>(entity, status_component_id);
        let state = status_component::get_status_state(status_component);
        if (state == b"online") {
            online_rule(status_component,clock)
        } else {
            offline_rule(status_component)
        }
    }
}
