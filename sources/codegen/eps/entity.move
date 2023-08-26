// module withinfinity::entity {
//     use sui::bag::Bag;
//     use sui::bag;
//     use sui::tx_context::TxContext;
//
//     struct Entity has store  {
//         components: Bag
//     }
//
//     friend withinfinity::pet_world;
//     friend withinfinity::pet_system;
//     friend withinfinity::home_system;
//     friend withinfinity::status_system;
//
//     public(friend) fun create_entity(ctx: &mut TxContext): Entity {
//         Entity {
//             components: bag::new(ctx)
//         }
//     }
//
//     public(friend) fun add_component<T: store>(entity: &mut Entity, component_id: vector<u8>, component:T){
//         let components = get_mut_components(entity);
//         bag::add(components, component_id, component);
//     }
//
//     public(friend) fun remove_component<T: drop + store>(entity: &mut Entity, component_id: vector<u8>){
//         let components= get_mut_components(entity);
//         bag::remove<vector<u8>,T>(components, component_id);
//     }
//
//     public(friend) fun get_mut_components(entity: &mut Entity): &mut Bag {
//         &mut entity.components
//     }
//
//     public(friend) fun get_component<T: store>(entity: &Entity, component_id: vector<u8>): &T {
//         assert!(bag::contains(&entity.components, component_id),0);
//         bag::borrow<vector<u8>,T>(&entity.components, component_id)
//     }
//
//     public(friend) fun get_mut_component<T: store>(entity: &mut Entity, component_id: vector<u8>): &mut T {
//         assert!(bag::contains(&entity.components, component_id),0);
//         bag::borrow_mut<vector<u8>,T>(&mut entity.components,component_id)
//     }
//
// }