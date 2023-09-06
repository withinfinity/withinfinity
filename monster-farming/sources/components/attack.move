module monster_farming::attack_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend monster_farming::attack_system;

    const COMPONENT_NAME: vector<u8> = b"Attack Component";

    public fun get_name(): vector<u8> {
        COMPONENT_NAME
    }

    struct AttackData has drop, store {
        attack_damage: u64,
        health: u64,
        level: u64,
    }

    public fun new( attack_damage: u64, health: u64, level: u64): AttackData {
        AttackData {
            attack_damage,
            health,
            level,
        }
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component<Table<vector<u8>,AttackData>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,AttackData>(ctx)
        );
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, attack_damage: u64, health: u64, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::add(component, key, new(attack_damage, health, level));
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, attack_damage: u64, health: u64, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        let data =  table::borrow_mut<vector<u8>, AttackData>(component, key);
        data.attack_damage = attack_damage;
        data.health = health;
        data.level = level;
        data.level = level;
    }

    public(friend) fun update_attack_damage(world : &mut World, key: vector<u8>, attack_damage: u64) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, AttackData>(component, key).attack_damage = attack_damage;
    }

    public(friend) fun update_health(world : &mut World, key: vector<u8>, health: u64) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, AttackData>(component, key).health = health;
    }

    public(friend) fun update_level(world : &mut World, key: vector<u8>, level: u64) {
        let component = world::get_mut_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, AttackData>(component, key).level = level;
    }

    public fun get(world : &World, key: vector<u8>) : (u64, u64, u64) {
        let component = world::get_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        let data = table::borrow<vector<u8>, AttackData>(component, key);
        (
            data.attack_damage,
            data.health,
            data.level
        )
    }

    public fun get_attack_damage(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, AttackData>(component, key).attack_damage
    }

    public fun get_health(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, AttackData>(component, key).health
    }

    public fun get_level(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, AttackData>(component, key).level
    }

    public fun contains(world : &World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,AttackData>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, AttackData>(component, key)
    }

}
