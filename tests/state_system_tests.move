#[test_only]
module withinfinity::state_system_tests {
    use sui::test_scenario;
    use withinfinity::world::World;
    use withinfinity::pet::Pet;
    use withinfinity::pet_system_tests::adopt_pet_test;
    use sui::clock;
    use sui::object;
    use withinfinity::world;
    use sui::clock::Clock;
    use withinfinity::state_system;
    use withinfinity::state::StateStorage;
    use withinfinity::state;
    use withinfinity::level::LevelStorage;
    use withinfinity::level;

    #[test_only]
    fun check_current_data(world: &World, pet: &Pet, clock : &Clock, state: vector<u8>, hunger_level:u64, cleanliness_level:u64,mood_level:u64,level:u64) {
        let (current_state ,current_hunger,current_cleanliness,current_mood,current_level) = state_system::get_pet_state_and_level(world, object::id(pet), clock);
        assert!(current_state == state, 0);
        assert!(current_hunger == hunger_level, 0);
        assert!(current_cleanliness == cleanliness_level, 0);
        assert!(current_mood == mood_level, 0);
        assert!(current_level == level, 0);

    }

    #[test_only]
    fun check_storage_data(world: &World, pet: &Pet, state: vector<u8>, hunger: u64, cleanliness: u64,mood: u64,level: u64) {
        let pet_id = object::id(pet);
        let state_storage = world::get_storage<StateStorage>(world,state::get_state_storage_key());
        let (storage_state , _) = state::get_state_data_all(state_storage, pet_id);

        let level_storage = world::get_storage<LevelStorage>(world,level::get_level_storage_key());
        let (storage_hunger , storage_cleanliness , storage_mood ,storage_level) = level::get_level_data_all(level_storage, pet_id);
        assert!(storage_state == state, 0);
        assert!(storage_hunger == hunger, 0);
        assert!(storage_cleanliness == cleanliness, 0);
        assert!(storage_mood == mood, 0);
        assert!(storage_level == level, 0);

    }

    #[test]
    fun get_pet_state_and_level_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);
        check_current_data(&world, &pet, &clock,b"online", 1000, 1200,900,0);
        check_storage_data(&world, &pet,b"online",1000,1200,900,0);

        clock::increment_for_testing(&mut clock, 59000);
        check_current_data(&world, &pet, &clock,b"online", 1000, 1200,900,0);
        check_storage_data(&world, &pet,b"online",1000,1200,900,0);

        clock::increment_for_testing(&mut clock, 60000);
        check_current_data(&world, &pet, &clock,b"online", 998,1197,899,0);
        check_storage_data(&world, &pet,b"online",1000,1200,900,0);

        clock::increment_for_testing(&mut clock, 3600000);
        check_current_data(&world, &pet,&clock,b"online",998 - 2 * 60,1197 - 3 * 60,899 - 60,1);
        check_storage_data(&world, &pet,b"online",1000,1200,900,0);

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
        check_current_data(&world, &pet,&clock,b"online",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_storage_data(&world, &pet,b"online",1000,1200,900,0);

        test_scenario::next_tx(scenario,@0x0001);
        {
            let ctx = test_scenario::ctx(scenario);
            state_system::logout(&mut world ,&pet, &clock,ctx);
        };

        test_scenario::next_tx(scenario,@0x0001);
        check_current_data(&world, &pet, &clock,b"offline", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_storage_data(&world, &pet,b"offline",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        clock::increment_for_testing(&mut clock, 3600000);
        check_current_data(&world, &pet, &clock,b"offline", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_storage_data(&world, &pet,b"offline",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        test_scenario::next_tx(scenario,@0x0001);
        {
            let ctx = test_scenario::ctx(scenario);
            state_system::login(&mut world ,&pet, &clock,ctx);
        };
        check_current_data(&world, &pet, &clock,b"online", 1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);
        check_storage_data(&world, &pet,b"online",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        clock::increment_for_testing(&mut clock, 3600000);
        check_current_data(&world, &pet, &clock,b"online", 1000 - 2 * 60 - 2 * 60,1200 - 3 * 60 - 3 * 60,900 - 60 - 60,2);
        check_storage_data(&world, &pet,b"online",1000 - 2 * 60,1200 - 3 * 60,900 - 60,1);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }
}