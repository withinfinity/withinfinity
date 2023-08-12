module earth::world {
    use sui::tx_context::TxContext;
    use eps::world::{create_world, add_entity_in_world, add_component, World};
    use sui::transfer;
    use eps::entity::{create_entity};
    use sui::clock::{Clock, timestamp_ms};
    use earth::age_component::gen_age;
    use crypto_pet::status_component::gen_status;



    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        let world = create_world(ctx);
        transfer::public_share_object(world);
    }

    /// add new entry to new world
    public entry fun add_entity_to_world(world: &mut World, ctx: &mut TxContext) {
        let entity = create_entity(ctx);
        add_entity_in_world(world,entity);
    }


    public entry fun set_status_component_to_entity(
        world: &mut World,
        entity_id: u64,
        ctx: &mut TxContext,
    ) {
        let stats = gen_status(ctx);
        add_component(world,entity_id,stats);
    }

    public entry fun set_age_component_to_entity(
        world: &mut World,
        entity_id: u64,
        clock:&Clock,
        ctx: &mut TxContext,
    ) {
        let age = timestamp_ms(clock);
        let age = gen_age(age,ctx);
        add_component(world,entity_id,age);
    }
}
