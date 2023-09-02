#[test_only]
module withinfinity::pet_system_tests {
    use sui::test_scenario;
    use withinfinity::pet_system;
    use withinfinity::init;
    use withinfinity::world::{World};
    use sui::clock;
    use sui::test_scenario::Scenario;
    use sui::clock::Clock;
    use withinfinity::pet::{ Self, Pet};
    use std::string;
    use withinfinity::info_component;

    #[test]
    fun pet_world_init_should_work() {
        let scenario_val = test_scenario::begin(@0x0001);
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init::init_world_for_testing(ctx);
        };
        test_scenario::next_tx(scenario,@0x0001);
        let world = test_scenario::take_shared<World>(scenario);

        let (name,descrption,bitrth_time) = info_component::get(&world);

        assert!(*string::bytes(&name) == b"Crypto Pet", 0);
        assert!(*string::bytes(&descrption) == b"Crypto Pet", 0);
        assert!(bitrth_time == 1000000, 0);

        test_scenario::return_shared<World>(world);
        test_scenario::end(scenario_val);
    }

    #[test_only]
    public fun adopt_pet_test(): (Scenario,World,Clock) {
        let scenario_val = test_scenario::begin(@0x0001);
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init::init_world_for_testing(ctx);
        };
        test_scenario::next_tx(scenario,@0x0001);

        let world = test_scenario::take_shared<World>(scenario);

        let ctx = test_scenario::ctx(scenario);
        let clock = clock::create_for_testing(ctx);
        clock::set_for_testing(&mut clock, 1000);
        pet_system::adopt_pet(&mut world, b"BaoLong0", false , &clock , ctx);

        test_scenario::next_tx(scenario,@0x0001);

        return (scenario_val,world,clock)
    }

    #[test]
    fun adopt_pet_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);
        let (name,sex,birth_time) = pet::get_pet_basic_info(&pet);
        assert!(name == b"BaoLong0",0);
        assert!(sex == false,0);
        assert!(birth_time == 1000,0);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }

    #[test]
    fun update_pet_name_should_work() {
        let (scenario_val, world, clock) = adopt_pet_test();
        let scenario = &mut scenario_val;

        let pet = test_scenario::take_from_sender<Pet>(scenario);

        {
            let ctx = test_scenario::ctx(scenario);
            pet_system::update_pet_name(&mut pet,b"BaoLong1", ctx);
        };

        test_scenario::next_tx(scenario,@0x0001);

        let (name,_,_) = pet::get_pet_basic_info(&pet);
        assert!(name == b"BaoLong1",0);

        test_scenario::return_shared<World>(world);
        test_scenario::return_to_sender<Pet>(scenario, pet);
        clock::destroy_for_testing(clock);
        test_scenario::end(scenario_val);
    }
}