module withinfinity::pet_system {
    use withinfinity::world::{World, get_mut_component};
    use sui::transfer;
    use sui::tx_context::{ Self, TxContext };
    use sui::clock::Clock;
    use withinfinity::pet::{ Self, Pet };
    use sui::clock;
    use sui::url;
    use robots::robots_nft::RobotsNFT;
    use withinfinity::world;
    use withinfinity::state_component::StateComponent;
    use withinfinity::state_component;
    use withinfinity::entity;
    use withinfinity::level_component::LevelComponent;
    use withinfinity::level_component;

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) {
        let image_url = url::new_unsafe_from_bytes(b"https://ipfs.io/ipfs/QmUygfragP8UmCa7aq19AHLttxiLw1ELnqcsQQpM5crgTF/10.png");
        let pet = pet::new_pet(name, sex, image_url, clock, ctx);
        let pet_id = entity::object_to_entity_key<Pet>(&pet);

        let state_component = world::get_mut_component<StateComponent>(world,state_component::get_component_name());
        state_component::add(state_component, pet_id, b"online", clock::timestamp_ms(clock));
        let level_component = world::get_mut_component<LevelComponent>(world,level_component::get_component_name());
        level_component::add(level_component, pet_id, 1000,1200,900,0);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    /// add suifren nft to world
    public entry fun suifren_pet(world: &mut World, suifren: &RobotsNFT, clock: &Clock, _ctx: &mut TxContext) {
        let pet_id = entity::object_to_entity_key<RobotsNFT>(suifren);

        let state_component = get_mut_component<StateComponent>(world,state_component::get_component_name());
        state_component::add(state_component, pet_id, b"online", clock::timestamp_ms(clock));
        let level_component = get_mut_component<LevelComponent>(world,level_component::get_component_name());
        level_component::add(level_component, pet_id, 1000,1200,900,0);
    }

    public entry fun update_pet_name(pet: &mut Pet, name: vector<u8>, _ctx: &mut TxContext) {
        pet::update_pet_name(pet, name)
    }
}




