module monster_farming::init {
    use withinfinity::world::World;
    use monster_farming::attack_component;
    use sui::tx_context::TxContext;

    entry fun init_system(world: &mut World, ctx: &mut TxContext) {
        attack_component::register(world, ctx);
    }
}
