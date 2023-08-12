module earth::river_system {
    use eps::world::{World, get_mut_entity};
    use eps::entity::{get_components};
    use earth::age_component::{Age, get_update_time, refresh_update_time};
    use sui::clock::Clock;
    use earth::stats_component::{Stats, change_stats, get_stats};
    use earth::time_system::get_time;
    use sui::bag;
    use sui::event;


    const Hour:u64 = 3600000u64;
    const Minute:u64 = 60000u64;
    const Second:u64 = 1000u64;


    struct Event has copy, drop, store {
        local_time:u64,
        update_time:u64,
        lapse:u64
    }

    public entry fun get_water(
        world:&mut World,
        entity_id: u64,
        age_component_id:u64,
        stats_component_id:u64,
        clock:&Clock,
    ){

        let entity = get_mut_entity(world,entity_id);
        let components= get_components(entity);
        // find age component
        let age:&mut Age = bag::borrow_mut<u64,Age>(components,age_component_id);

        // get time intervals
        let update_time = get_update_time(age);
        let local_time =  get_time(clock);
        let lapse = (local_time - update_time) / Hour;

        event::emit(Event {
            local_time,
            update_time,
            lapse
        });
        // update time intervals
        refresh_update_time(age,local_time);

        let stats:&mut Stats = bag::borrow_mut<u64,Stats>(components,stats_component_id);
        let (energy,water ) = get_stats(stats);
        let new_energy:u64 = energy - (lapse * 1u64) ;
        let new_water:u64 = water  - (lapse * 1u64);
        if( (new_energy < energy) == (new_water < water) ){
            let new_energy:u64 = energy - 2u64 ;
            let new_water:u64 = water + 1u64 ;
            change_stats(stats,new_energy,new_water);
        }else{
            change_stats(stats,0u64,0u64);
        }
    }
}
