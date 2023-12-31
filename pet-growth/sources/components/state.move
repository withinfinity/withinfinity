module pet_growth::state_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend pet_growth::fee_system;
    friend pet_growth::home_system;
    friend pet_growth::pet_system;
    friend pet_growth::state_system;

    const COMPONENT_NAME: vector<u8> = b"State Component";

    public fun get_component_name() : vector<u8> {
        COMPONENT_NAME
    }

    struct StateData has drop, store {
        state: vector<u8>,
        last_update_time: u64
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component<Table<vector<u8>,StateData>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,StateData>(ctx)
        );
    }

    public fun new(state: vector<u8>, last_update_time: u64): StateData {
        StateData {
            state,
            last_update_time
        }
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, state: vector<u8>, last_update_time: u64) {
        let component = world::get_mut_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::add(component, key, new(state, last_update_time));
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, state: vector<u8>, last_update_time: u64) {
        let component = world::get_mut_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        let data =  table::borrow_mut<vector<u8>, StateData>(component, key);
        data.state = state;
        data.last_update_time = last_update_time;
    }


    public(friend) fun update_state(world : &mut World, key: vector<u8>, state: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, StateData>(component, key).state = state;
    }

    public(friend) fun update_last_update_time(world : &mut World, key: vector<u8>, last_update_time: u64) {
        let component = world::get_mut_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, StateData>(component, key).last_update_time = last_update_time
    }

    public fun get(world : &World, key: vector<u8>) : (vector<u8>, u64) {
        let component = world::get_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        let data = table::borrow<vector<u8>, StateData>(component, key);
        (
            data.state,
            data.last_update_time
        )
    }

    public fun get_state(world : &World, key: vector<u8>) : vector<u8> {
        let component = world::get_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, StateData>(component, key).state
    }

    public fun get_last_update_time(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, StateData>(component, key).last_update_time
    }

    public fun contains(world : &World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,StateData>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, StateData>(component, key)
    }

}
