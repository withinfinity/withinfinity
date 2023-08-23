#[test_only]
module withinfinity::status_system_tests {
    use sui::test_scenario;
    use eps::world::World;
    use withinfinity::pet_component::Pet;
    use withinfinity::pet_system_tests::adopt_pet_test;
    use sui::clock;
    use withinfinity::status_system;
    use sui::object;
    use withinfinity::status_component;
    use eps::world;
    use withinfinity::status_component::Status;
    use eps::entity;
    use sui::clock::Clock;

    #[test_only]
    fun get_status(world: &World, pet: &Pet): &Status {
        let entity = world::get_entity(world, object::id(pet));
        let status_component_id = status_component::get_component_id();
        entity::get_component<Status>(entity, status_component_id)
    }

    #[test_only]
    fun check_storage_data(world: &World, pet: &Pet,state: vector<u8>, hunger_level:u64, cleanliness_level:u64,mood_level:u64,level:u64) {
        let status = get_status(world, pet);
        let (storage_hunger_level,storage_cleanliness_level,storage_mood_level,storage_level) = status_component::get_status_level(status);
        assert!(status_component::get_status_state(status) == state, 0);
        assert!(storage_hunger_level == hunger_level, 0);
        assert!(storage_cleanliness_level == cleanliness_level, 0);
        assert!(storage_mood_level == mood_level, 0);
        assert!(storage_level == level, 0);

    }

    #[test_only]
    fun check_cache_data(world: &World, pet: &Pet, clock: &Clock, state: vector<u8>, hunger_level:u64, cleanliness_level:u64,mood_level:u64,level:u64) {
        let (cache_state, cache_hunger_level, cache_cleanliness_level,cache_mood_level,cache_level) = status_system::get_pet_state(world, object::id(pet),clock);
        assert!(cache_state == state, 0);
        assert!(cache_hunger_level == hunger_level, 0);
        assert!(cache_cleanliness_level == cleanliness_level, 0);
        assert!(cache_mood_level == mood_level, 0);
        assert!(cache_level == level, 0);

    }

    #[test]
    fun get_current_state_consume_time_ms_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);
        let status_component = get_status(&world, &pet);

        clock::increment_for_testing(&mut clock, 5000);
        let consume_time_ms = status_system::get_current_state_consume_time_ms(status_component, &clock);
        assert!(consume_time_ms == 5000,0);

        clock::increment_for_testing(&mut clock, 5000);
        let consume_time_ms = status_system::get_current_state_consume_time_ms(status_component, &clock);
        assert!(consume_time_ms == 10000,0);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }

    #[test]
    fun get_pet_state_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);
        check_storage_data(&world, &pet, b"online", 1000, 1200,900,0);
        check_cache_data(&world, &pet,&clock,b"online",1000,1200,900,0);

        clock::increment_for_testing(&mut clock, 59000);
        check_cache_data(&world, &pet,&clock,b"online",1000,1200,900,0);

        clock::increment_for_testing(&mut clock, 60000);
        check_cache_data(&world, &pet,&clock,b"online",998,1197,899,0);

        clock::increment_for_testing(&mut clock, 3600000);
        check_cache_data(&world, &pet,&clock,b"online",998 - 2 * 60,1197 - 3 * 60,899 - 60,1);

        check_storage_data(&world, &pet, b"online", 1000, 1200,900,0);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }

    #[test]
    fun login_and_logout_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);

        clock::increment_for_testing(&mut clock, 3600000);
        check_cache_data(&world, &pet,&clock,b"online",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        test_scenario::next_tx(scenario,@0x0001);
        {
            let ctx = test_scenario::ctx(scenario);
            status_system::logout(&mut world ,&pet, &clock,ctx);
        };

        test_scenario::next_tx(scenario,@0x0001);
        check_storage_data(&world, &pet, b"offline", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_cache_data(&world, &pet,&clock,b"offline",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        clock::increment_for_testing(&mut clock, 3600000);
        check_storage_data(&world, &pet, b"offline", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_cache_data(&world, &pet,&clock,b"offline",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        test_scenario::next_tx(scenario,@0x0001);
        {
            let ctx = test_scenario::ctx(scenario);
            status_system::login(&mut world ,&pet, &clock,ctx);
        };
        check_storage_data(&world, &pet, b"online", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_cache_data(&world, &pet,&clock,b"online",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        clock::increment_for_testing(&mut clock, 3600000);
        check_storage_data(&world, &pet, b"online", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_cache_data(&world, &pet,&clock,b"online",1000 - 2 * 60 - 2 * 60,1200 - 3 * 60 - 3 * 60,900 - 60 - 60,2);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }
}