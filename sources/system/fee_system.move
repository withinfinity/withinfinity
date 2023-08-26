module withinfinity::fee_system {
    use withinfinity::world::{World, add_entity_in_world, get_mut_entity};
    use withinfinity::fee::FeeInfo;
    use sui::tx_context::TxContext;
    use withinfinity::fee;
    use sui::table;

    public entry fun init_system(world: &mut World, ctx: &mut TxContext) {
        add_entity_in_world(
            world,
            fee::get_entity_key(),
            fee::new_fee_info(ctx),
            ctx
        );
    }

    public entry fun set_operation_fee(world: &mut World, operation: vector<u8>, fee: u64, ctx: &mut TxContext){
        let fee_entity_key = fee::get_entity_key();
        let fee_info = get_mut_entity<FeeInfo>(world , fee_entity_key , ctx);
        let fee_info_table = fee::get_mut_fee_info(fee_info);
        if (table::contains(fee_info_table,operation)) {
            *table::borrow_mut(fee_info_table,operation) = fee;
        } else {
            table::add(fee_info_table, operation, fee);
        };
    }
}
