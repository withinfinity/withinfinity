module withinfinity::pet {
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::object::UID;
    use sui::clock::{timestamp_ms, Clock};

    struct Pet has key , store {
        id: UID,
        name: vector<u8>,
        sex: bool,
        birth_time: u64,
    }

    public fun new_pet(name: vector<u8>, sex: bool, clock: &Clock, ctx: &mut TxContext) : Pet {
        Pet {
            id: object::new(ctx),
            name,
            sex,
            birth_time: timestamp_ms(clock)
        }
    }

    public fun set_pet_name(pet: &mut Pet, name: vector<u8>) {
        pet.name = name
    }

    public fun get_pet_basic_info(pet: &Pet): (vector<u8>, bool, u64) {
        (
            pet.name,
            pet.sex,
            pet.birth_time,
        )
    }
}
