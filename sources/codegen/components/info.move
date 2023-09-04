module withinfinity::info_component {
    use std::string::{Self, String};
    use withinfinity::world::{ Self, World};

    // Systems
    friend withinfinity::fee_system;
    friend withinfinity::home_system;
    friend withinfinity::pet_system;
    friend withinfinity::state_system;

    const COMPONENT_NAME: vector<u8> = b"Info Component";

    struct InfoData has drop, store {
        name: String,
        description: String,
        birth_time: u64,
    }

    public fun new(name: String, description: String, birth_time: u64): InfoData {
        InfoData {
            name,
            description,
            birth_time
        }
    }

    public fun register(world: &mut World) {
        world::add_component<InfoData>(
            world,
            COMPONENT_NAME,
            new(
                string::utf8(b"Crypto Pet"),
                string::utf8(b"Crypto Pet"),
                1000000
            )
        );
    }

    public(friend) fun update(world : &mut World, name: String, description: String, birth_time: u64) {
        let data = world::get_mut_component<InfoData>(world, COMPONENT_NAME);
        data.name = name;
        data.description = description;
        data.birth_time = birth_time;
    }

    public fun get(world : &World): (String , String, u64) {
        let data = world::get_component<InfoData>(world, COMPONENT_NAME);
        (
            data.name,
            data.description,
            data.birth_time,
        )
    }

}
