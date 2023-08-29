module withinfinity::level_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    const COMPONENT_NAME: vector<u8> = b"Level Component";

    public fun get_component_name() : vector<u8> {
        COMPONENT_NAME
    }

    struct LevelData has drop, store {
        hunger: u64,
        cleanliness: u64,
        mood: u64,
        level: u64,
    }

    struct LevelComponent has store {
        table: Table<vector<u8>,LevelData>,
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
        world::add_component_in_world<LevelComponent>(
            world,
            COMPONENT_NAME,
            LevelComponent {
                table: table::new<vector<u8>,LevelData>(ctx)
            }
        );
    }

    public(friend) fun add(component : &mut LevelComponent, key: vector<u8>, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        table::add(&mut component.table, key, new(hunger, cleanliness, mood, level));
    }

    public(friend) fun remove(component : &mut LevelComponent, key: vector<u8>) {
        table::remove(&mut component.table, key);
    }

    public(friend) fun update(component : &mut LevelComponent, key: vector<u8>, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        let data =  table::borrow_mut<vector<u8>, LevelData>(&mut component.table, key);
        data.hunger = hunger;
        data.cleanliness = cleanliness;
        data.mood = mood;
        data.level = level;
    }

    public(friend) fun update_hunger(component: &mut LevelComponent, key: vector<u8>, hunger: u64) {
        table::borrow_mut<vector<u8>, LevelData>(&mut component.table, key).hunger = hunger;
    }

    public(friend) fun update_cleanliness(component: &mut LevelComponent, key: vector<u8>, cleanliness: u64) {
        table::borrow_mut<vector<u8>, LevelData>(&mut component.table, key).cleanliness = cleanliness;
    }

    public(friend) fun update_mood(component: &mut LevelComponent, key: vector<u8>, mood: u64) {
        table::borrow_mut<vector<u8>, LevelData>(&mut component.table, key).mood = mood;
    }

    public(friend) fun update_level(component: &mut LevelComponent, key: vector<u8>, level: u64) {
        table::borrow_mut<vector<u8>, LevelData>(&mut component.table, key).level = level;
    }

    public fun get(component: &LevelComponent, key: vector<u8>) : (u64, u64, u64, u64) {
        let data = table::borrow<vector<u8>, LevelData>(&component.table, key);
        (
            data.hunger,
            data.cleanliness,
            data.mood,
            data.level
        )
    }

    public fun get_hunger(component: &LevelComponent, key: vector<u8>) : u64 {
        table::borrow<vector<u8>, LevelData>(&component.table, key).hunger
    }

    public fun get_cleanliness(component: &LevelComponent, key: vector<u8>) : u64 {
        table::borrow<vector<u8>, LevelData>(&component.table, key).cleanliness
    }

    public fun get_level_date_mood(component: &LevelComponent, key: vector<u8>) : u64 {
        table::borrow<vector<u8>, LevelData>(&component.table, key).mood
    }

    public fun get_level(component: &LevelComponent, key: vector<u8>) : u64 {
        table::borrow<vector<u8>, LevelData>(&component.table, key).level
    }

    public(friend) fun contains(state_component : &mut LevelComponent, key: vector<u8>) {
        table::borrow_mut<vector<u8>, LevelData>(&mut state_component.table, key);
    }

}
