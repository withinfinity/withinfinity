module withinfinity::fee {
    use sui::table;
    use sui::table::Table;
    use sui::tx_context::TxContext;

    struct FeeInfo has store {
        value: Table<vector<u8>,u64>
    }

    public fun new_fee_info(ctx:&mut TxContext): FeeInfo {
        FeeInfo {
            value: table::new<vector<u8>, u64>(ctx)
        }
    }

    public fun get_operation_fee(fee_info: &FeeInfo, operation: vector<u8>) : u64 {
        *table::borrow<vector<u8>, u64>(&fee_info.value, operation)
    }

    public fun get_mut_fee_info(fee_info: &mut FeeInfo) : &mut Table<vector<u8>, u64> {
        &mut fee_info.value
    }

    public fun get_entity_key() : vector<u8> {
        b"Fee Entity"
    }
}
