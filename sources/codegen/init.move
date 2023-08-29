module withinfinity::init {
    use sui::transfer;
    use sui::tx_context::TxContext;
    use withinfinity::world;
    use withinfinity::level_component;
    use withinfinity::state_component;
    use withinfinity::fee_config;
    use withinfinity::admin_config;
    use withinfinity::info_config;

    fun init(ctx: &mut TxContext) {
        let world = world::create_world(ctx);

        // Component register
        level_component::register(&mut world,ctx);
        state_component::register(&mut world,ctx);

        // Genesis Config
        world::add_config_in_world(
            &mut world,
            admin_config::get_config_name(),
            admin_config::get_init_value()
        );
        world::add_config_in_world(
            &mut world,
            fee_config::get_config_name(),
            fee_config::get_init_value(ctx)
        );
        world::add_config_in_world(
            &mut world,
            info_config::get_config_name(),
            info_config::get_init_value()
        );

        transfer::public_share_object(world);
    }
}
