module crypto_pet::pet_world {
    use sui::tx_context::TxContext;
    use eps::world::{create_world, add_custom_entity_in_world};
    use sui::transfer;
    use crypto_pet::fee;

    const NAME: vector<u8> = b"Crypto Pet";
    const DESCRIPTION: vector<u8> = b"A pet raising game";

    fun init(ctx: &mut TxContext) {
        let world = create_world(ctx, NAME, DESCRIPTION);
        let fee_info = fee::new_fee_info(ctx);
        add_custom_entity_in_world(&mut world, b"Fee Entity", fee_info, ctx);
        transfer::public_share_object(world);
    }

    #[test_only]
    public fun pet_world_init(ctx: &mut TxContext) {
        init(ctx)
    }
}
