module pet_growth::home_system {
    use withinfinity::world::World;
    use sui::clock::Clock;
    use withinfinity::pet::Pet;
    use pet_growth::state_system;
    use pet_growth::level_component;
    use pet_growth::entity_key;

    const Hour:u64 = 3600000u64;
    const Minute:u64 = 60000u64;
    const Second:u64 = 1000u64;

    public entry fun bathe_pet(world: &mut World, pet: &Pet, clock: &Clock){
        let pet_id = entity_key::object_to_entity_key(pet);
        let (state, hunger,cleanliness,mood,level) = state_system::get_pet_state_and_level(world, pet_id, clock);
        assert!(state == b"online", 0);
        cleanliness = cleanliness + 50;
        mood = mood + 10;

        level_component::update(world, pet_id , hunger, cleanliness,mood, level);
    }

    public entry fun play_with_pet(world:&mut World, pet: &Pet, clock: &Clock){
        let pet_id = entity_key::object_to_entity_key(pet);
        let (state, hunger,cleanliness,mood,level) = state_system::get_pet_state_and_level(world, pet_id, clock);
        assert!(state == b"online", 0);
        hunger = hunger + 20;
        mood = mood + 50;

        level_component::update(world, pet_id , hunger, cleanliness,mood, level);
    }
}
