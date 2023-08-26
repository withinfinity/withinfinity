module withinfinity::world {
    use sui::object::{UID, ID};
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::bag::Bag;
    use sui::bag;
    use sui::tx_context;
    use sui::hash::keccak256;

    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::pet_world;
    friend withinfinity::state_system;

    #[test_only]
    friend withinfinity::pet_system_tests;
    #[test_only]
    friend withinfinity::state_system_tests;

    struct World has key, store{
        id: UID,
        /// Owner of the world
        owner: address,
        /// Name for the world
        name: vector<u8>,
        /// Description of the world
        description: vector<u8>,
        /// Storages of the world
        storages: Bag,
        /// entity set
        entities: Bag
    }


    public(friend) fun create_world(ctx: &mut TxContext, name: vector<u8>, description: vector<u8>): World {
        World {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            name,
            description,
            storages: bag::new(ctx),
            entities:bag::new(ctx)
        }
    }

    public(friend) fun get_world_owner(world: &World): address {
        world.owner
    }

    public(friend) fun get_world_name(world: &World): vector<u8> {
        world.name
    }

    public(friend) fun get_world_description(world: &World): vector<u8> {
        world.description
    }

    public(friend) fun get_storage<T : store>(world: &World, storage_key: vector<u8>): &T {
        let storage_key = keccak256(&storage_key);
        let storage_id = object::id_from_bytes(storage_key);
        bag::borrow<ID, T>(&world.storages, storage_id)
    }

    public(friend) fun get_mut_storage<T : store>(world: &mut World, storage_key: vector<u8>): &mut T {
        let storage_key = keccak256(&storage_key);
        let storage_id = object::id_from_bytes(storage_key);
        bag::borrow_mut<ID, T>(&mut world.storages, storage_id)
    }

    public(friend) fun add_storage_in_world<T : store>(world: &mut World, storage_key: vector<u8>, storage: T, ctx: &mut TxContext){
        let storage_key = keccak256(&storage_key);
        let storage_id = object::id_from_bytes(storage_key);
        let owner = get_world_owner(world);
        assert!(tx_context::sender(ctx) == owner, 0);
        bag::add<ID,T>(&mut world.storages, storage_id, storage);
    }

    public(friend) fun remove_storage_from_world<T : store>(world: &mut World, storage_key: vector<u8>, ctx: &mut TxContext): T {
        let storage_key = keccak256(&storage_key);
        let storage_id = object::id_from_bytes(storage_key);
        let owner = get_world_owner(world);
        assert!(tx_context::sender(ctx) == owner, 0);
        bag::remove<ID,T>(&mut world.storages, storage_id)
    }

    public(friend) fun storage_contains(world: &mut World, storage_key: vector<u8>): bool {
        let storage_key = keccak256(&storage_key);
        let storage_id = object::id_from_bytes(storage_key);
        bag::contains(&mut world.storages, storage_id)
    }

    public(friend) fun get_entity<T : store>(world: &World, entity_key: vector<u8>): &T {
        let entity_key = keccak256(&entity_key);
        let entity_id = object::id_from_bytes(entity_key);
        bag::borrow<ID,T>(&world.entities, entity_id)
    }

    public(friend) fun get_mut_entity<T : store>(world: &mut World, entity_key: vector<u8>, ctx: &mut TxContext): &mut T {
        let owner = get_world_owner(world);
        assert!(tx_context::sender(ctx) == owner, 0);
        let entity_key = keccak256(&entity_key);
        let entity_id = object::id_from_bytes(entity_key);
        bag::borrow_mut<ID, T>(&mut world.entities, entity_id)
    }

    public(friend) fun add_entity_in_world<T : store>(world: &mut World, entity_key: vector<u8>, obj: T, ctx: &mut TxContext){
        let owner = get_world_owner(world);
        assert!(tx_context::sender(ctx) == owner, 0);
        let entity_key = keccak256(&entity_key);
        let entity_id = object::id_from_bytes(entity_key);
        bag::add(&mut world.entities, entity_id, obj);
    }

    public(friend) fun remove_entity_from_world<T : key + store>(world: &mut World, entity_key: vector<u8>, ctx: &mut TxContext) : T {
        let owner = get_world_owner(world);
        assert!(tx_context::sender(ctx) == owner, 0);
        let entity_key = keccak256(&entity_key);
        let entity_id = object::id_from_bytes(entity_key);
        bag::remove<ID, T>(&mut world.entities, entity_id)
    }
}
