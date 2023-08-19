module crypto_pet::status_system {
    use eps::world::World;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use crypto_pet::pet_component::Pet;
    use eps::world;
    use eps::entity;
    use crypto_pet::status_component;
    use crypto_pet::status_component::Status;

    public entry fun login(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"login", clock)
    }

    public entry fun logout(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"logout", clock)
    }

    public entry fun clean(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"clean", clock)
    }

    fun update_state(world: &mut World, pet: &Pet, state: vector<u8>,  clock: &Clock) {
        let status_component_id = status_component::get_component_id();
        let (old_state,hunger_level,cleanliness_level,mood_level,level) = get_pet_state(world, pet, clock);
        assert!(state != old_state,0);
        let entity = world::get_mut_entity(world, pet);
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        status_component::set_status_state_time(status_component,b"clean",hunger_level,cleanliness_level,mood_level,level,clock);
    }

    // ============================================ View Functions ============================================
    public fun get_pet_state(world: &mut World, pet: &Pet , clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let entity = world::get_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_component<Status>(entity, status_component_id);
        let state = status_component::get_status_state(status_component);
        if (state == b"login") {
            status_component::login_rule(status_component,clock)
        } else {
            status_component::logout_rule(status_component)
        }
    }
}
