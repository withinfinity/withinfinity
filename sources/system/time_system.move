// module earth::time_system {
//     use sui::clock::{timestamp_ms, Clock};
//     use sui::event;
//     use sui::clock;
//
//
//     struct TimeEvent has copy, drop, store {
//         timestamp_ms: u64
//     }
//
//     public entry fun get_time(clock: &Clock): u64{
//         event::emit(TimeEvent {
//             timestamp_ms: clock::timestamp_ms(clock),
//         });
//         timestamp_ms(clock)
//     }
// }
