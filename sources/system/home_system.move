// module crypto_pet::home_system {
//     use eps::world::{World, get_mut_entity};
//     use eps::entity::{get_components};
//     use sui::clock::Clock;
//     use sui::bag;
//     use crypto_pet::status_component::{Status, change_status};
//     // use crypto_pet::work_system::change_stats;
//
//
//     const Hour:u64 = 3600000u64;
//     const Minute:u64 = 60000u64;
//     const Second:u64 = 1000u64;
//
//
//     public entry fun clean(
//         world:&mut World,
//         entity_id: u64,
//         status_component_id:u64,
//         clock:&Clock,
//     ){
//
//         // let entity = get_mut_entity(world,entity_id);
//         // let components= get_components(entity);
//         // // find status component
//         // let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//
//     }
//
//     public entry fun stop_clean(
//         world:&mut World,
//         entity_id: u64,
//         status_component_id:u64,
//         clock:&Clock,
//     ){
//
//         // let entity = get_mut_entity(world,entity_id);
//         // let components= get_components(entity);
//         // // find status component
//         // let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//
//     }
//
//     public entry fun play(
//         world:&mut World,
//         entity_id: u64,
//         status_component_id:u64,
//         clock:&Clock,
//     ){
//
//         let entity = get_mut_entity(world,entity_id);
//         let components= get_components(entity);
//         // find status component
//         let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//         change_status()
//     }
//
//     public entry fun stop_to_play(
//         world:&mut World,
//         entity_id: u64,
//         status_component_id:u64,
//         clock:&Clock,
//     ){
//         let entity = get_mut_entity(world,entity_id);
//         let components= get_components(entity);
//         // find status component
//         let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//
//     }
// }
