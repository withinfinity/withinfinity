// module crypto_pet::home_system {
//     use eps::world::{World};
//     use sui::clock::Clock;
//     use crypto_pet::status_component::{Status, change_status, get_state, get_hunger_and_cleanliness_level, get_mood_and_level};
//     use sui::object;
//     use eps::world;
//     use eps::entity;
//     use crypto_pet::pet_component::Pet;
//     use sui::tx_context::TxContext;
//     use crypto_pet::status_component;
//
//
//     const Hour:u64 = 3600000u64;
//     const Minute:u64 = 60000u64;
//     const Second:u64 = 1000u64;
//
//     public entry fun enter_home(world: &mut World, pet: &mut Pet, clock: &Clock, _ctx: &mut TxContext) {
//         let entity = world::get_mut_entity(world, pet);
//         let status_component_id = status_component::get_component_id();
//         let status_component = entity::get_mut_component<Status>(entity, status_component_id);
//         assert!(status_component::get_status_state(status_component) != b"athome",0);
//         status_component::set_status_state_time(status_component,b"athome",clock);
//     }
//
//     // public entry fun clean<T : key + store>(
//     //     world:&mut World,
//     //     entity_key: &T,
//     //     components_id:vector<u8>,
//     //     _clock:&Clock,
//     // ){
//     //     let id = object::id(entity_key);
//     //     let entity = world::get_mut_entity(world, id);
//     //     let status_component = entity::get_mut_component<Status>(entity, components_id);
//     //     let state = get_state(status_component);
//     //     let (hunger_level,cleanliness_level) = get_hunger_and_cleanliness_level(status_component);
//     //     let (mood_level,level) = get_mood_and_level(status_component);
//     //     let new_hunger_level = hunger_level - 2;
//     //     let new_cleanliness_level  = cleanliness_level + 1;
//     //     change_status(status_component,state,new_hunger_level,new_cleanliness_level,mood_level,level);
//     // }
//     //
//     // public entry fun stop_clean(
//     //     world:&mut World,
//     //     entity_id: u64,
//     //     status_component_id:u64,
//     //     clock:&Clock,
//     // ){
//     //
//     //     // let entity = get_mut_entity(world,entity_id);
//     //     // let components= get_components(entity);
//     //     // // find status component
//     //     // let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//     //
//     // }
//     //
//     // public entry fun play(
//     //     world:&mut World,
//     //     entity_id: u64,
//     //     status_component_id:u64,
//     //     clock:&Clock,
//     // ){
//     //
//     //     let entity = get_mut_entity(world,entity_id);
//     //     let components= get_components(entity);
//     //     // find status component
//     //     let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//     //     change_status()
//     // }
//     //
//     // public entry fun stop_to_play(
//     //     world:&mut World,
//     //     entity_id: u64,
//     //     status_component_id:u64,
//     //     clock:&Clock,
//     // ){
//     //     let entity = get_mut_entity(world,entity_id);
//     //     let components= get_components(entity);
//     //     // find status component
//     //     let status:&mut Status = bag::borrow_mut<u64,Status>(components,status_component_id);
//     //
//     // }
// }
