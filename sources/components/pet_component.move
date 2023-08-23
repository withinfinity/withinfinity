module withinfinity::pet_component {
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::object::UID;


    struct Pet has key , store {
        id: UID,
    }

    public fun new_pet(ctx: &mut TxContext) : Pet {
        Pet {
            id: object::new(ctx),
        }
    }

}
