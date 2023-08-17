module crypto_pet::pet_centre {
    use eps::world::{World, add_entity_in_world, add_component};
    use eps::entity::{ create_entity};
    use sui::object;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use components::name::{new_name, update_name};
    use components::sex::new_sex;
    use components::birth_time::new_birth_time;
    use sui::clock::Clock;
    use crypto_pet::pet_component::{new_pet, Pet};

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool,clock: &Clock, ctx: &mut TxContext) {
        let pet = new_pet(ctx);
        let entity_key = object::id(&pet);

        let entity = create_entity(ctx);
        let name_component = new_name(name);
        let sex_component = new_sex(sex);
        let birth_component = new_birth_time(clock);

        add_entity_in_world(world, entity_key, entity);

        add_component(world,entity_key,name_component);
        add_component(world,entity_key,sex_component);
        add_component(world,entity_key,birth_component);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    public entry fun update_pet_name(world: &mut World, pet: &Pet, name: vector<u8>, _: &mut TxContext) {
        update_name(world, pet, name);
    }
}
