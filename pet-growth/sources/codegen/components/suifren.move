module pet_growth::suifren_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend pet_growth::fee_system;
    friend pet_growth::home_system;
    friend pet_growth::pet_system;
    friend pet_growth::state_system;

    const COMPONENT_NAME: vector<u8> = b"Suifren Component";

    struct SuifrenData has drop, store {
        value: bool
    }

    public fun new( value: bool): SuifrenData {
        SuifrenData {
            value
        }
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component<Table<vector<u8>,SuifrenData>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,SuifrenData>(ctx)
        );
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, value: bool) {
        let component = world::get_mut_component<Table<vector<u8>,SuifrenData>>(world, COMPONENT_NAME);
        table::add(component, key, new(value));
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,SuifrenData>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, value: bool) {
        let component = world::get_mut_component<Table<vector<u8>,SuifrenData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, SuifrenData>(component, key).value = value;
    }

    public fun get(world : &World, key: vector<u8>) : bool {
        let component = world::get_component<Table<vector<u8>,SuifrenData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, SuifrenData>(component, key).value
    }

    public fun contains(world : &mut World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,SuifrenData>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, SuifrenData>(component, key)
    }

}
