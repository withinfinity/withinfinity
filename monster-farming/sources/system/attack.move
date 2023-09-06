module monster_farming::attack_system {
    use withinfinity::world::World;
    use sui::tx_context::TxContext ;
    use withinfinity::pet::Pet ;
    use monster_farming::entity_key;
    use monster_farming::attack_component;
    use monster_farming::monster_component;

    public entry fun resiter(world: &mut World, pet: &Pet, _ctx: &mut TxContext) {
        let pet_id = entity_key::object_to_entity_key<Pet>(pet);
        attack_component::add(world, pet_id, 100,  50, 0);
    }

    public entry fun add_monster(world: &mut World, monster_name: vector<u8>, _ctx: &mut TxContext) {
        let monster_id = entity_key::monster_to_entity_key(monster_name);
        monster_component::add(world, monster_id, 10, 10);
    }

    public entry fun pet_restore_health(world: &mut World, pet: &Pet, _ctx: &mut TxContext) {
        let pet_id = entity_key::object_to_entity_key<Pet>(pet);
        attack_component::update_health(world, pet_id, 50);
    }

    public entry fun petAttack(world: &mut World, pet: &Pet, monster_name: vector<u8>) {
        let pet_id = entity_key::object_to_entity_key<Pet>(pet);
        let monster_id = entity_key::monster_to_entity_key(monster_name);

        let (monster_attack_damage, monster_health) = monster_component::get(world, monster_id);
        let (pet_attack_damage, pet_health, level) = attack_component::get(world, pet_id);

        if (monster_attack_damage >= pet_health) {
            attack_component::update_health(world, pet_id,  0);
        };

        if (monster_attack_damage < pet_health) {
            attack_component::update_health(world, pet_id,  pet_health - monster_attack_damage);
        };

        if (pet_attack_damage >= monster_health) {
            attack_component::update_attack_damage(world, pet_id,  pet_attack_damage + 5);
            attack_component::update_level(world, pet_id, level + 1);
        };
    }
}




