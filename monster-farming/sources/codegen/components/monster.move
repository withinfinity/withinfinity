module monster_farming::monster_component {
    use sui::tx_context::TxContext;
    use sui::table::{ Self, Table };
    use withinfinity::world::{ Self , World };

    // Systems
    friend monster_farming::attack_system;

    const COMPONENT_NAME: vector<u8> = b"Monster Component";

    public fun get_name(): vector<u8> {
        COMPONENT_NAME
    }

    struct MonsterData has drop, store {
        attack_damage: u64,
        health: u64,
    }

    public fun new( attack_damage: u64, health: u64): MonsterData {
        MonsterData {
            attack_damage,
            health,
        }
    }

    public fun register(world: &mut World, ctx: &mut TxContext) {
        world::add_component<Table<vector<u8>,MonsterData>>(
            world,
            COMPONENT_NAME,
            table::new<vector<u8>,MonsterData>(ctx)
        );
    }

    public(friend) fun add(world : &mut World, key: vector<u8>, attack_damage: u64, health: u64) {
        let component = world::get_mut_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::add(component, key, new(attack_damage, health));
    }

    public(friend) fun remove(world : &mut World, key: vector<u8>) {
        let component = world::get_mut_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::remove(component, key);
    }

    public(friend) fun update(world : &mut World, key: vector<u8>, attack_damage: u64, health: u64) {
        let component = world::get_mut_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        let data =  table::borrow_mut<vector<u8>, MonsterData>(component, key);
        data.attack_damage = attack_damage;
        data.health = health;
    }

    public(friend) fun update_attack_damage(world : &mut World, key: vector<u8>, attack_damage: u64) {
        let component = world::get_mut_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, MonsterData>(component, key).attack_damage = attack_damage;
    }

    public(friend) fun update_health(world : &mut World, key: vector<u8>, health: u64) {
        let component = world::get_mut_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::borrow_mut<vector<u8>, MonsterData>(component, key).health = health;
    }

    public fun get(world : &World, key: vector<u8>) : (u64, u64) {
        let component = world::get_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        let data = table::borrow<vector<u8>, MonsterData>(component, key);
        (
            data.attack_damage,
            data.health,
        )
    }

    public fun get_attack_damage(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, MonsterData>(component, key).attack_damage
    }

    public fun get_health(world : &World, key: vector<u8>) : u64 {
        let component = world::get_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::borrow<vector<u8>, MonsterData>(component, key).health
    }

    public fun contains(world : &World, key: vector<u8>): bool {
        let component = world::get_component<Table<vector<u8>,MonsterData>>(world, COMPONENT_NAME);
        table::contains<vector<u8>, MonsterData>(component, key)
    }

}
