module pet_growth::level_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend pet_growth::fee_system;
    friend pet_growth::home_system;
    friend pet_growth::pet_system;
    friend pet_growth::state_system;

    const COMPONENT_NAME: vector<u8> = b"Level Component";

    struct LevelData has drop, store {
        hunger: u64,
        cleanliness: u64,
        mood: u64,
        level: u64,
    }

    public fun new( hunger: u64, cleanliness: u64, mood: u64, level: u64): LevelData {
        LevelData {
            hunger,
            cleanliness,
            mood,
            level
        }
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component<Table<vector<u8>,LevelData>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,LevelData>(ctx)
        );
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::add(component, key, new(hunger, cleanliness, mood, level));
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        let data =  table::borrow_mut<vector<u8>, LevelData>(component, key);
        data.hunger = hunger;
        data.cleanliness = cleanliness;
        data.mood = mood;
        data.level = level;
    }

    public(friend) fun update_hunger(world : &mut World, key: vector<u8>, hunger: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, LevelData>(component, key).hunger = hunger;
    }

    public(friend) fun update_cleanliness(world : &mut World, key: vector<u8>, cleanliness: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, LevelData>(component, key).cleanliness = cleanliness;
    }

    public(friend) fun update_mood(world : &mut World, key: vector<u8>, mood: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, LevelData>(component, key).mood = mood;
    }

    public(friend) fun update_level(world : &mut World, key: vector<u8>, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, LevelData>(component, key).level = level;
    }

    public fun get(world : &World, key: vector<u8>) : (u64, u64, u64, u64) {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        let data = table::borrow<vector<u8>, LevelData>(component, key);
        (
            data.hunger,
            data.cleanliness,
            data.mood,
            data.level
        )
    }

    public fun get_hunger(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, LevelData>(component, key).hunger
    }

    public fun get_cleanliness(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, LevelData>(component, key).cleanliness
    }

    public fun get_level_date_mood(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, LevelData>(component, key).mood
    }

    public fun get_level(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, LevelData>(component, key).level
    }

    public fun contains(world : &World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,LevelData>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, LevelData>(component, key)
    }

}
