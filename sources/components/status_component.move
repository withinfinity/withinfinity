module crypto_pet::status_component {
    use components::utils::generate_component_id;
    use sui::clock::Clock;
    use sui::clock;
    use sui::table;
    use sui::table::Table;
    use sui::tx_context::TxContext;

    const COMPONENT_NAME: vector<u8> = b"CryptoPet component status";

    const Hour:u64 = 3600000u64;

    struct Status has store {
        state: vector<u8>,
        state_time: Table<vector<u8>,u64>,
        hunger_level: u64,
        cleanliness_level: u64,
        mood_level: u64,
        level: u64,
    }

    public fun new_status(ctx:&mut TxContext): Status{
        Status {
            state: b"online",
            state_time: table::new(ctx),
            hunger_level: 1000u64,
            cleanliness_level: 1200u64,
            mood_level: 900u64,
            level: 0u64,
        }
    }

    public fun get_status_state(status: &Status) : vector<u8> {
        status.state
    }

    public fun get_status_state_time(status: &Status) : &Table<vector<u8>,u64> {
        &status.state_time
    }

    public fun get_mut_status_state_time(status: &mut Status) : &mut Table<vector<u8>,u64> {
        &mut status.state_time
    }

    public fun set_status_state_time(status: &mut Status,state: vector<u8>, hunger_level:u64,cleanliness_level:u64,mood_level:u64,level:u64,clock: &Clock) {
        let state_time = get_mut_status_state_time(status);
        if (table::contains(state_time,state)) {
            *table::borrow_mut(state_time,state) = clock::timestamp_ms(clock);
        } else {
            table::add(state_time,state,clock::timestamp_ms(clock));
        };
        status.state = state;
        set_status_level(status,hunger_level,cleanliness_level,mood_level,level)
    }

    public fun get_status_level(status: &Status) : (u64,u64,u64,u64) {
        (
            status.hunger_level,
            status.cleanliness_level,
            status.mood_level,
            status.level,
        )
    }

    public fun set_status_level(status: &mut Status,hunger_level:u64,cleanliness_level:u64,mood_level:u64,level: u64) {
        status.hunger_level = hunger_level;
        status.cleanliness_level = cleanliness_level;
        status.mood_level = mood_level;
        status.level = level;
    }

    public fun get_component_id() : vector<u8> {
        generate_component_id(COMPONENT_NAME)
    }

}
