// module crypto_pet::resource_component {
//     use sui::object::UID;
//     use sui::tx_context::TxContext;
//     use sui::object;
//
//
//
//     struct Resource has key, store {
//         id:UID,
//         gold:u64
//     }
//
//     public fun gen_resource(ctx: &mut TxContext): Resource{
//         Resource{
//             id: object::new(ctx),
//             gold:0u64
//         }
//     }
//
//     public fun get_resource(resource:&mut Resource) :u64{
//         resource.gold
//     }
//
//
// }
