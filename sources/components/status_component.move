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

    public fun get_current_state_consume_time_ms(status: &Status,clock: &Clock) : u64 {
        let state_time_table = get_status_state_time(status);
        let state_time = table::borrow(state_time_table,status.state);
        let current_time = clock::timestamp_ms(clock);
        current_time - *state_time
    }

    public fun login_rule(status: &Status,clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let consume_time_ms = get_current_state_consume_time_ms(status, clock);
        let (hunger_level, cleanliness_level, mood_level, level) = get_status_level(status);
        let consume_time_m = consume_time_ms / 60000u64;
        if (hunger_level > consume_time_m * 2) {
            hunger_level = hunger_level - consume_time_m * 2;
        } else {
            hunger_level = 0;
        };

        if (cleanliness_level > consume_time_m * 3) {
            cleanliness_level = cleanliness_level - consume_time_m * 3;
        }else {
            cleanliness_level = 0;
        };

        if (mood_level > consume_time_m * 1) {
            mood_level = mood_level - consume_time_m * 1;
        } else {
            mood_level = 0;
        };

        level = level + consume_time_m / 60u64;
        return (status.state, hunger_level,cleanliness_level,mood_level,level)
    }

    public fun logout_rule(status: &Status) : (vector<u8>,u64,u64,u64,u64) {
        let (hunger_level, cleanliness_level, mood_level, level) = get_status_level(status);
        return (status.state, hunger_level,cleanliness_level,mood_level,level)
    }

    public fun get_component_id() : vector<u8> {
        generate_component_id(COMPONENT_NAME)
    }

}
