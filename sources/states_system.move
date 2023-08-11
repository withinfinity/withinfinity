module crypto_pet::work_system {
    use eps::world::{World, get_mut_entity};
    use eps::entity::get_component;

    public entry fun change_stats(
        world:&mut World,
        entity_id: u64,
        component_id:u64,
        energy:u64,
        water:u64
    ) {
        let entity = get_mut_entity(world,entity_id);
        let stats = get_component(entity,component_id);
        earth::states_component::change_stats(
            stats,
            energy,
            water
        );
    }
}
