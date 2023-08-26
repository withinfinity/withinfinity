module withinfinity::pet_system {
    use withinfinity::world::{World, add_storage_in_world, storage_contains, get_mut_storage};
    use sui::transfer;
    use sui::tx_context::{ Self, TxContext };
    use sui::clock::Clock;
    use withinfinity::pet::{ Self, Pet };
    use withinfinity::state;
    use withinfinity::level;
    use sui::clock;
    use sui::object;
    use withinfinity::state::StateStorage;
    use withinfinity::level::LevelStorage;
    use sui::url;

    public entry fun init_system(world: &mut World, ctx: &mut TxContext) {
        add_storage_in_world(
            world,
            state::get_state_storage_key(),
            state::new_state_storage(ctx),
            ctx
        );

        add_storage_in_world(
            world,
            level::get_level_storage_key(),
            level::new_level_storage(ctx),
            ctx
        )
    }

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) {
        assert!(storage_contains(world, level::get_level_storage_key()), 0);
        let image_url = url::new_unsafe_from_bytes(b"https://ipfs.io/ipfs/QmUygfragP8UmCa7aq19AHLttxiLw1ELnqcsQQpM5crgTF/10.png");
        let pet = pet::new_pet(name, sex, image_url, clock, ctx);
        let pet_id = object::id(&pet);

        let state_storage = get_mut_storage<StateStorage>(world,state::get_state_storage_key());
        state::insert_state_data_all(state_storage, pet_id, b"online", clock::timestamp_ms(clock));
        let level_storage = get_mut_storage<LevelStorage>(world,level::get_level_storage_key());
        level::insert_level_data_all(level_storage, pet_id, 1000,1200,900,0);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    public entry fun set_pet_name(pet: &mut Pet, name: vector<u8>, _ctx: &mut TxContext) {
        pet::set_pet_name(pet, name)
    }
}




