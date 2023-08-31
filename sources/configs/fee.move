module withinfinity::fee_config {

    use sui::table::Table;
    use sui::table;
    use sui::tx_context::TxContext;

    public fun get_config_name() : vector<u8> {
        b"Fee Config"
    }

    public fun get_init_value(ctx: &mut TxContext) : Table<vector<u8>,u64> {
        let fee_table = table::new<vector<u8>,u64>(ctx);
        table::add(&mut fee_table, b"clean", 1000000);
        table::add(&mut fee_table, b"paly", 1000000);
        fee_table
    }

}
