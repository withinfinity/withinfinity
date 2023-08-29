module withinfinity::state_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    const COMPONENT_NAME: vector<u8> = b"State Component";

    public fun get_component_name() : vector<u8> {
        COMPONENT_NAME
    }

    struct StateData has drop, store {
        state: vector<u8>,
        last_update_time: u64
    }

    struct StateComponent has store {
        table: Table<vector<u8>, StateData>,
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component_in_world<StateComponent>(
            world,
            COMPONENT_NAME,
            StateComponent {
                table: table::new<vector<u8>, StateData>(ctx)
            }
        );
    }

    public fun new(state: vector<u8>, last_update_time: u64): StateData {
        StateData {
            state,
            last_update_time
        }
    }

    public(friend) fun add(component : &mut StateComponent, key: vector<u8>, state: vector<u8>, last_update_time: u64) {
        table::add(&mut component.table, key, new(state, last_update_time));
    }

    public(friend) fun remove(component : &mut StateComponent, key: vector<u8>) {
        table::remove(&mut component.table, key);
    }

    public(friend) fun update(component : &mut StateComponent, key: vector<u8>, state: vector<u8>, last_update_time: u64) {
        let data =  table::borrow_mut<vector<u8>, StateData>(&mut component.table, key);
        data.state = state;
        data.last_update_time = last_update_time;
    }


    public(friend) fun update_state(component: &mut StateComponent, key: vector<u8>, state: vector<u8>) {
        table::borrow_mut<vector<u8>, StateData>(&mut component.table, key).state = state;
    }

    public(friend) fun update_last_update_time(component: &mut StateComponent, key: vector<u8>, last_update_time: u64) {
        table::borrow_mut<vector<u8>, StateData>(&mut component.table, key).last_update_time = last_update_time
    }

    public fun get(component: &StateComponent, key: vector<u8>) : (vector<u8>, u64) {
        let data = table::borrow<vector<u8>, StateData>(&component.table, key);
        (
            data.state,
            data.last_update_time
        )
    }

    public fun get_state(component: &StateComponent, key: vector<u8>) : vector<u8> {
        table::borrow<vector<u8>, StateData>(&component.table, key).state
    }

    public fun get_last_update_time(component: &StateComponent, key: vector<u8>) : u64 {
        table::borrow<vector<u8>, StateData>(&component.table, key).last_update_time
    }

    public(friend) fun contains(component : &mut StateComponent, key: vector<u8>) {
        table::borrow_mut<vector<u8>, StateData>(&mut component.table, key);
    }

}
