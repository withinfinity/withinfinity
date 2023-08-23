module crypto_pet::fee_system {
    use eps::world::{World, get_mut_custom_entity};
    use crypto_pet::fee::FeeInfo;
    use sui::tx_context::TxContext;
    use crypto_pet::fee;
    use sui::table;

    public entry fun set_operation_fee(world: &mut World, operation: vector<u8>, fee: u64, ctx: &mut TxContext){
        let fee_entity_key = fee::get_entity_key();
        let fee_info = get_mut_custom_entity<FeeInfo>(world , fee_entity_key , ctx);
        let fee_info_table = fee::get_mut_fee_info(fee_info);
        if (table::contains(fee_info_table,operation)) {
            *table::borrow_mut(fee_info_table,operation) = fee;
        } else {
            table::add(fee_info_table, operation, fee);
        };
    }
}
