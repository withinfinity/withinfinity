module withinfinity::suifren_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    const COMPONENT_NAME: vector<u8> = b"Suifren Component";

    public fun get_component_name() : vector<u8> {
        COMPONENT_NAME
    }

    struct SuifrenComponent has store {
        table: Table<vector<u8>,bool>,
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component_in_world<SuifrenComponent>(
            world,
            COMPONENT_NAME,
            SuifrenComponent {
                table: table::new<vector<u8>,bool>(ctx)
            }
        );
    }

    public(friend) fun add(component : &mut SuifrenComponent, key: vector<u8>, value: bool) {
        table::add(&mut component.table, key, value);
    }

    public(friend) fun remove(component : &mut SuifrenComponent, key: vector<u8>) {
        table::remove(&mut component.table, key);
    }

    public(friend) fun update(component : &mut SuifrenComponent, key: vector<u8>, value: bool) {
        *table::borrow_mut<vector<u8>, bool>(&mut component.table, key) = value;
    }

    public fun get(component: &SuifrenComponent, key: vector<u8>) : bool {
        *table::borrow<vector<u8>, bool>(&component.table, key)
    }

    public(friend) fun contains(state_component : &mut SuifrenComponent, key: vector<u8>) {
        table::borrow_mut<vector<u8>, bool>(&mut state_component.table, key);
    }

}
