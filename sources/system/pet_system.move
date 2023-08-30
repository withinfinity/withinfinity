module withinfinity::pet_system {
    use withinfinity::world::World;
    use sui::transfer;
    use sui::tx_context::{ Self, TxContext };
    use sui::clock::Clock;
    use withinfinity::pet::{ Self, Pet };
    use sui::clock;
    use sui::url;
    use robots::robots_nft::RobotsNFT;
    use withinfinity::state_component;
    use withinfinity::entity_key;
    use withinfinity::level_component;

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) {
        let image_url = url::new_unsafe_from_bytes(b"https://ipfs.io/ipfs/QmUygfragP8UmCa7aq19AHLttxiLw1ELnqcsQQpM5crgTF/10.png");
        let pet = pet::new_pet(name, sex, image_url, clock, ctx);
        let pet_id = entity_key::object_to_entity_key<Pet>(&pet);

        state_component::add(world, pet_id, b"online", clock::timestamp_ms(clock));
        level_component::add(world, pet_id, 1000,1200,900,0);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    /// add suifren nft to world
    public entry fun suifren_pet(world: &mut World, suifren: &RobotsNFT, clock: &Clock, _ctx: &mut TxContext) {
        let pet_id = entity_key::object_to_entity_key<RobotsNFT>(suifren);

        state_component::add(world, pet_id, b"online", clock::timestamp_ms(clock));
        level_component::add(world, pet_id, 1000,1200,900,0);
    }

    public entry fun update_pet_name(pet: &mut Pet, name: vector<u8>, _ctx: &mut TxContext) {
        pet::update_pet_name(pet, name)
    }
}




