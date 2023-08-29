module withinfinity::info_config {
    use std::string::String;
    use std::string;

    struct InfoConfig has store {
        name: String,
        description: String,
        birth_time: u64,
    }

    public fun new(name: String, description: String, birth_time: u64): InfoConfig {
        InfoConfig {
            name,
            description,
            birth_time
        }
    }

    public fun get(config: &InfoConfig): (String , String, u64) {
        (
            config.name,
            config.description,
            config.birth_time,
        )
    }

    public(friend) fun update(config: &mut InfoConfig, name: String, description: String, birth_time: u64) {
        config.name = name;
        config.description = description;
        config.birth_time = birth_time;
    }

    public fun get_config_name() : vector<u8> {
        b"Info Config"
    }

    public fun get_init_value() : InfoConfig {
       new(
            string::utf8(b"Crypto Pet"),
            string::utf8(b"Crypto Pet"),
            1000000
        )
    }

}
