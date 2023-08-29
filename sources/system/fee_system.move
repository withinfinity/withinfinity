module withinfinity::fee_system {
    use withinfinity::world::World;
    use sui::tx_context::TxContext;
    use withinfinity::fee_config;
    use withinfinity::world;
    use sui::table::Table;
    use sui::table;

    public entry fun update_operation_fee(world: &mut World, operation: vector<u8>, fee: u64, _ctx: &mut TxContext){
        let fee_config_name = fee_config::get_config_name();
        let fee_table = world::get_mut_config<Table<vector<u8>,u64>>(world, fee_config_name);
        if (table::contains(fee_table,operation)) {
            *table::borrow_mut(fee_table,operation) = fee;
        } else {
            table::add(fee_table, operation, fee);
        };
    }
}
