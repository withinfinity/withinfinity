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

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component_in_world<Table<vector<u8>,bool>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,bool>(ctx)
        );
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, value: bool) {
        let component = world::get_mut_component<Table<vector<u8>,bool>>(world, COMPONENT_NAME);
        table::add(component, key, value);
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,bool>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, value: bool) {
        let component = world::get_mut_component<Table<vector<u8>,bool>>(world, COMPONENT_NAME);
        *table::borrow_mut<vector<u8>, bool>(component, key) = value;
    }

    public fun get(world : &World, key: vector<u8>) : bool {
        let component = world::get_component<Table<vector<u8>,bool>>(world, COMPONENT_NAME);
        *table::borrow<vector<u8>, bool>(component, key)
    }

    public fun contains(world : &mut World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,bool>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, bool>(component, key)
    }

}
