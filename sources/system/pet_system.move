module withinfinity::pet_system {
    use eps::world::{World, add_entity_in_world };
    use eps::entity::{create_entity, add_component };
    use sui::transfer;
    use sui::tx_context::{ Self, TxContext };
    use sui::clock::Clock;
    use withinfinity::pet_component::{ Self, Pet };
    use withinfinity::status_component;

    /// add new pet to world
    public entry fun adopt_pet(world: &mut World, name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) {
        let pet = pet_component::new_pet(name, sex, clock, ctx);

        let entity = create_entity(ctx);
        let status_component =  status_component::new_status(ctx, clock);

        add_component(&mut entity,status_component::get_component_id(),status_component);

        add_entity_in_world(world, &pet, entity);

        transfer::public_transfer(pet, tx_context::sender(ctx));
    }

    public entry fun set_pet_name(pet: &mut Pet, name: vector<u8>, _ctx: &mut TxContext) {
        pet_component::set_pet_name(pet, name)
    }
}




