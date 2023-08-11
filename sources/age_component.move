module earth::age_component {
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::object;



    struct Age has key, store {
        id:UID,
        age:u64,
        update_time:u64
    }

    public fun gen_age(age:u64,ctx: &mut TxContext): Age{
        Age{
            id: object::new(ctx),
            age,
            update_time:age
        }
    }

    public fun get_age(age:&mut Age) :(u64,u64){
        (age.age,age.update_time)
    }


    public fun refresh_update_time(age:&mut Age,update_time:u64){
        age.update_time = update_time
    }

}
