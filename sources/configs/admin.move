module withinfinity::admin_config {

    public fun get_config_name() : vector<u8> {
        b"Admin Config"
    }

    public fun get_init_value() : address {
        @0x1
    }

}
