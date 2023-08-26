module withinfinity::pet {
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::object::UID;
    use sui::clock::{timestamp_ms, Clock};
    use sui::url::Url;
    use std::string;
    use sui::package;
    use sui::display;
    use sui::tx_context;
    use sui::transfer;

    struct Pet has key , store {
        id: UID,
        name: vector<u8>,
        sex: bool,
        birth_time: u64,
        image_url: Url,
    }

    /// One-Time-Witness for the module.
    struct PET has drop {}

    fun init(otw: PET, ctx: &mut TxContext) {
        let keys = vector[
            string::utf8(b"name"),
            string::utf8(b"sex"),
            string::utf8(b"birth_time"),
            string::utf8(b"image_url"),
        ];

        let values = vector[
            string::utf8(b"{name}"),
            string::utf8(b"{sex}"),
            string::utf8(b"{birth_time}"),
            string::utf8(b"{image_url}"),
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Hero` type.
        let display = display::new_with_fields<Pet>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }

    public fun new_pet(name: vector<u8>, sex: bool, image_url: Url, clock: &Clock, ctx: &mut TxContext) : Pet {
        Pet {
            id: object::new(ctx),
            name,
            sex,
            birth_time: timestamp_ms(clock),
            image_url,
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
