module crypto_pet::pet_system {
    use eps::world::World;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use crypto_pet::pet_component::Pet;
    use eps::world;
    use eps::entity;
    use crypto_pet::status_component;
    use crypto_pet::status_component::Status;

    public entry fun login(world: &mut World, pet: &mut Pet, clock: &Clock, _ctx: &mut TxContext) {
        let entity = world::get_mut_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        assert!(status_component::get_status_state(status_component) != b"online",0);
        status_component::set_status_state_time(status_component,b"online",clock);
    }

    public entry fun logout(world: &mut World, pet: &mut Pet, clock: &Clock, _ctx: &mut TxContext) {
        let entity = world::get_mut_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        assert!(status_component::get_status_state(status_component) != b"offline",0);
        status_component::set_status_state_time(status_component,b"offline",clock);
    }
}
