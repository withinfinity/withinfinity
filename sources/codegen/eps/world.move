module withinfinity::world {
    use sui::tx_context::TxContext;
    use sui::hash::keccak256;
    use sui::bag::{ Self, Bag };
    use sui::object::{ Self, UID };

    // init
    friend withinfinity::init;

    // components
    friend withinfinity::level_component;
    friend withinfinity::state_component;
    friend withinfinity::suifren_component;

    // systems
    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    struct World has key, store{
        id: UID,
        /// Components of the world
        components: Bag,
        /// configs update
        configs: Bag
    }

    public(friend) fun create_world(ctx: &mut TxContext): World {
        World {
            id: object::new(ctx),
            components: bag::new(ctx),
            configs: bag::new(ctx)
        }
    }

    public(friend) fun get_component<T : store>(world: &World, component_id: vector<u8>): &T {
        let component_id = keccak256(&component_id);
        bag::borrow<vector<u8>, T>(&world.components, component_id)
    }

    public(friend) fun get_mut_component<T : store>(world: &mut World, component_id: vector<u8>): &mut T {
        let component_id = keccak256(&component_id);
        bag::borrow_mut<vector<u8>, T>(&mut world.components, component_id)
    }

    public(friend) fun add_component_in_world<T : store>(world: &mut World, component_id: vector<u8>, storage: T){
        let component_id = keccak256(&component_id);
        bag::add<vector<u8>,T>(&mut world.components, component_id, storage);
    }

    public(friend) fun remove_component_from_world<T : store>(world: &mut World, component_id: vector<u8>): T {
        let component_id = keccak256(&component_id);
        bag::remove<vector<u8>,T>(&mut world.components, component_id)
    }

    public(friend) fun component_contains(world: &mut World, component_id: vector<u8>): bool {
        let component_id = keccak256(&component_id);
        let storage_id = object::id_from_bytes(component_id);
        bag::contains(&mut world.components, storage_id)
    }

    public(friend) fun get_config<T : store>(world: &World, config_id: vector<u8>): &T {
        let config_id = keccak256(&config_id);
        bag::borrow<vector<u8>, T>(&world.components, config_id)
    }

    public(friend) fun get_mut_config<T : store>(world: &mut World, config_id: vector<u8>): &mut T {
        let config_id = keccak256(&config_id);
        bag::borrow_mut<vector<u8>, T>(&mut world.configs, config_id)
    }

    public(friend) fun add_config_in_world<T : store>(world: &mut World, config_id: vector<u8>, config: T){
        let config_id = keccak256(&config_id);
        bag::add<vector<u8>,T>(&mut world.components, config_id, config);
    }

    public(friend) fun remove_config_from_world<T : store>(world: &mut World, config_id: vector<u8>): T {
        let config_id = keccak256(&config_id);
        bag::remove<vector<u8>,T>(&mut world.components, config_id)
    }

    public(friend) fun config_contains(world: &mut World, config_id: vector<u8>): bool {
        let config_id = keccak256(&config_id);
        bag::contains(&mut world.components, config_id)
    }
}
