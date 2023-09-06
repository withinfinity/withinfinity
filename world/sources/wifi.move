module withinfinity::wifi {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url;

    const SYMBOL: vector<u8> = b"WIFI";
    const NAME: vector<u8> = b"With Infinity Token";
    const DESCRIPTION: vector<u8> = b"With Infinity Token";
    const ICON_URL: vector<u8> = b"https://blog.sui.io/content/images/2023/04/Sui_Droplet_Logo_Blue-3.png";
    const DECIMALS: u8 = 8;
    // 10e
    const MAX_SUPPLY: u64 = 1000000000 * 100000000;

    struct WIFI has drop {}
    
    fun init(witness: WIFI, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<WIFI>(
            witness,
            DECIMALS,
            SYMBOL,
            NAME,
            DESCRIPTION,
            option::some(url::new_unsafe_from_bytes(ICON_URL)),
            ctx
        );

        let receiver = tx_context::sender(ctx);

        coin::mint_and_transfer(&mut treasury_cap, MAX_SUPPLY, receiver, ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, receiver)
    }

    /// Manager can mint new coins
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<WIFI>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn coins
    public entry fun burn(treasury_cap: &mut TreasuryCap<WIFI>, coin: Coin<WIFI>) {
        coin::burn(treasury_cap, coin);
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(WIFI {}, ctx)
    }
}