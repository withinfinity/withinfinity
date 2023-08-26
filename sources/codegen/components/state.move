module withinfinity::state {
    use sui::tx_context::TxContext;
    use sui::object::ID;
    use sui::table::Table;
    use sui::table;

    // friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    #[test_only]
    friend withinfinity::state_system_tests;

    struct StateData has store {
        state: vector<u8>,
        last_update_time: u64
    }

    struct StateStorage has store {
        state_data: Table<ID, StateData>,
    }

    public(friend) fun new_state_storage(ctx: &mut TxContext): StateStorage {
        StateStorage {
            state_data: table::new<ID, StateData>(ctx)
        }
    }

    public(friend) fun new_state_data(state: vector<u8>, last_update_time: u64): StateData {
        StateData {
            state,
            last_update_time
        }
    }

    public(friend) fun get_state_data_state(state_storage: &StateStorage, key: ID) : vector<u8> {
        table::borrow<ID, StateData>(&state_storage.state_data, key).state
    }

    public(friend) fun get_state_data_last_update_time(state_storage: &StateStorage, key: ID) : u64 {
        table::borrow<ID, StateData>(&state_storage.state_data, key).last_update_time
    }

    public(friend) fun get_state_data_all(state_storage: &StateStorage, key: ID) : (vector<u8>, u64) {
        let data = table::borrow<ID, StateData>(&state_storage.state_data, key);
        (
            data.state,
            data.last_update_time
        )
    }

    public(friend) fun set_state_data_state(state_storage: &mut StateStorage, key: ID, state: vector<u8>) {
        table::borrow_mut<ID, StateData>(&mut state_storage.state_data, key).state = state;
    }

    public(friend) fun set_state_data_last_update_time(state_storage: &mut StateStorage, key: ID, last_update_time: u64) {
        table::borrow_mut<ID, StateData>(&mut state_storage.state_data, key).last_update_time = last_update_time
    }

    public(friend) fun set_state_data_all(state_storage : &mut StateStorage, key: ID, state: vector<u8>, last_update_time: u64) {
        let data =  table::borrow_mut<ID, StateData>(&mut state_storage.state_data, key);
        data.state = state;
        data.last_update_time = last_update_time;
    }

    public(friend) fun insert_state_data_all(state_storage : &mut StateStorage, key: ID, state: vector<u8>, last_update_time: u64) {
        table::add<ID, StateData>(&mut state_storage.state_data, key, new_state_data(state, last_update_time));
    }

    public(friend) fun contains(state_storage : &mut StateStorage, key: ID) {
        table::borrow_mut<ID, StateData>(&mut state_storage.state_data, key);
    }

    public(friend) fun get_state_storage_key() : vector<u8> {
        b"State Storage"
    }

}
