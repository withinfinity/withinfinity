module withinfinity::init {
    use sui::transfer;
    use sui::tx_context::TxContext;
    use withinfinity::world;
    use withinfinity::admin_component;
    use withinfinity::info_component;

    fun init(ctx: &mut TxContext) {
        let world = world::create_world(ctx);

        // singleton component
        admin_component::register(&mut world);
        info_component::register(&mut world);

        transfer::public_share_object(world);
    }

    #[test_only]
    public fun init_world_for_testing(ctx: &mut TxContext){
        init(ctx)
    }
}
