module crypto_pet::status_component {
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::object;

    const Hour:u64 = 3600000u64;

    struct Status has key, store {
        id: UID,
        state:vector<u8>,
        hunger_level:u64,
        cleanliness_level:u64,
        mood_level:u64,
        level:u64,
    }

    public fun gen_status(ctx: &mut TxContext): Status{
        Status{
            id: object::new(ctx),
            state:b"alive",
            hunger_level:120u64,
            cleanliness_level:120u64,
            mood_level:120u64,
            level:0u64,
        }
    }


    public fun change_status(
        status: &mut Status,
        state:vector<u8>,
        hunger_level:u64,
        cleanliness_level:u64,
        mood_level:u64,
        level:u64,
    ) {
        status.state = state;
        status.hunger_level = hunger_level;
        status.cleanliness_level = cleanliness_level;
        status.mood_level = mood_level;
        status.level = level;
    }

    public fun get_state(status: &mut Status) : vector<u8>{
        status.state
    }

    public fun get_hunger_and_cleanliness_level(status: &mut Status) : (u64,u64){
        (status.hunger_level,status.cleanliness_level)
    }
    public fun get_mood_and_level(status: &mut Status) : (u64,u64){
        (status.mood_level,status.level)
    }

}
