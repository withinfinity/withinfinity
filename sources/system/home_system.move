module withinfinity::home_system {
    use eps::world::World;
    use sui::clock::Clock;
    use withinfinity::status_component::Status;
    use sui::object;
    use eps::world;
    use eps::entity;
    use withinfinity::pet_component::Pet;
    use withinfinity::status_component;
    use withinfinity::status_system;


    const Hour:u64 = 3600000u64;
    const Minute:u64 = 60000u64;
    const Second:u64 = 1000u64;

    public entry fun bathe_pet(world:&mut World, pet: &Pet, clock: &Clock){
        let (state, hunger_level,cleanliness_level,mood_level,level) = status_system::get_pet_state(world, object::id(pet), clock);
        assert!(state == b"at_home",0);
        cleanliness_level = cleanliness_level + 50;
        mood_level = mood_level + 10;
        let entity = world::get_mut_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        status_component::set_status_state_and_time_and_level(status_component,b"at_home", hunger_level, cleanliness_level, mood_level, level, clock);
    }

    public entry fun play_with_pet(world:&mut World, pet: &Pet, clock: &Clock){
        let (state, hunger_level,cleanliness_level,mood_level,level) = status_system::get_pet_state(world, object::id(pet), clock);
        assert!(state == b"at_home",0);
        if (cleanliness_level > 10) {
            cleanliness_level = cleanliness_level - 10;
        } else {
            cleanliness_level = 0;
        };

        if (hunger_level > 10) {
            hunger_level = hunger_level - 10;
        } else {
            hunger_level = 0;
        };

        mood_level = mood_level + 50;
        let entity = world::get_mut_entity(world, pet);
        let status_component_id = status_component::get_component_id();
        let status_component = entity::get_mut_component<Status>(entity, status_component_id);
        status_component::set_status_state_and_time_and_level(status_component,b"at_home", hunger_level, cleanliness_level, mood_level, level, clock);
    }
}
