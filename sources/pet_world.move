module crypto_pet::pet_world {
    use sui::tx_context::TxContext;
    use eps::world::{create_world};
    use sui::transfer;

    const NAME: vector<u8> = b"Crypto Pet";
    const DESCRIPTION: vector<u8> = b"A pet raising game";

    fun init(ctx: &mut TxContext) {
        let world = create_world(ctx, NAME, DESCRIPTION);
        transfer::public_share_object(world);
    }
}
