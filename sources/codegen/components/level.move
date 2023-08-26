module withinfinity::level {
    use sui::tx_context::TxContext;
    use sui::object::ID;
    use sui::table::Table;
    use sui::table;

    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    #[test_only]
    friend withinfinity::state_system_tests;

    struct LevelData has store {
        hunger: u64,
        cleanliness: u64,
        mood: u64,
        level: u64,
    }

    struct LevelStorage has store {
        level_data: Table<ID,LevelData>,
    }

    public(friend) fun new_level_storage(ctx: &mut TxContext): LevelStorage {
        LevelStorage {
            level_data: table::new<ID,LevelData>(ctx)
        }
    }

    public(friend) fun new_level_data( hunger: u64, cleanliness: u64, mood: u64, level: u64): LevelData {
        LevelData {
            hunger,
            cleanliness,
            mood,
            level
        }
    }

    public(friend) fun get_level_data_hunger(level_storage: &LevelStorage, key: ID) : u64 {
        table::borrow<ID, LevelData>(&level_storage.level_data, key).hunger
    }

    public(friend) fun get_level_data_cleanliness(level_storage: &LevelStorage, key: ID) : u64 {
        table::borrow<ID, LevelData>(&level_storage.level_data, key).cleanliness
    }

    public(friend) fun get_level_date_mood(level_storage: &LevelStorage, key: ID) : u64 {
        table::borrow<ID, LevelData>(&level_storage.level_data, key).mood
    }

    public(friend) fun get_level_data_level(level_storage: &LevelStorage, key: ID) : u64 {
        table::borrow<ID, LevelData>(&level_storage.level_data, key).level
    }

    public(friend) fun get_level_data_all(level_storage: &LevelStorage, key: ID) : (u64, u64, u64, u64) {
        let data = table::borrow<ID, LevelData>(&level_storage.level_data, key);
        (
            data.hunger,
            data.cleanliness,
            data.mood,
            data.level
        )
    }

    public(friend) fun set_level_data_hunger(level_storage: &mut LevelStorage, key: ID, hunger: u64) {
        table::borrow_mut<ID, LevelData>(&mut level_storage.level_data, key).hunger = hunger;
    }

    public(friend) fun set_level_data_cleanliness(level_storage: &mut LevelStorage, key: ID, cleanliness: u64) {
        table::borrow_mut<ID, LevelData>(&mut level_storage.level_data, key).cleanliness = cleanliness;
    }

    public(friend) fun set_level_data_mood(level_storage: &mut LevelStorage, key: ID, mood: u64) {
        table::borrow_mut<ID, LevelData>(&mut level_storage.level_data, key).mood = mood;
    }

    public(friend) fun set_level_data_level(level_storage: &mut LevelStorage, key: ID, level: u64) {
        table::borrow_mut<ID, LevelData>(&mut level_storage.level_data, key).level = level;
    }

    public(friend) fun set_level_data_all(level_storage : &mut LevelStorage, key: ID, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        let data =  table::borrow_mut<ID, LevelData>(&mut level_storage.level_data, key);
        data.hunger = hunger;
        data.cleanliness = cleanliness;
        data.mood = mood;
        data.level = level;
    }

    public(friend) fun insert_level_data_all(level_storage : &mut LevelStorage, key: ID, hunger: u64, cleanliness: u64, mood: u64, level: u64) {
        table::add<ID, LevelData>(&mut level_storage.level_data, key, new_level_data(hunger, cleanliness, mood, level));
    }

    public(friend) fun get_level_storage_key() : vector<u8> {
        b"Level Storage"
    }

}
