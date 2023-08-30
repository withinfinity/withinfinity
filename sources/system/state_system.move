module withinfinity::state_system {
    use withinfinity::world::World;
    use sui::clock::Clock;
    use sui::clock;
    use withinfinity::state_component;
    use withinfinity::level_component;
    use withinfinity::pet::Pet;
    use sui::tx_context::TxContext;
    use withinfinity::entity_key;

    const Hour:u64 = 3600000u64;
    const Minute:u64 = 60000u64;
    const Second:u64 = 1000u64;

    public entry fun login(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"online", clock)
    }

    public entry fun logout(world: &mut World, pet: &Pet, clock: &Clock, _ctx: &mut TxContext) {
        update_state(world, pet, b"offline", clock)
    }

    fun update_state(world: &mut World, pet: &Pet, state: vector<u8>,  clock: &Clock) {
        let pet_id = entity_key::object_to_entity_key(pet);
        let (old_state,hunger,cleanliness,mood,level) = get_pet_state_and_level(world, pet_id, clock);
        assert!(state != old_state, 0);

        state_component::update(world, pet_id,state, clock::timestamp_ms(clock));

        if (old_state != b"offline") {
            level_component::update(world, pet_id , hunger, cleanliness,mood, level)
        };
    }

    fun online_rule(consume_time: u64, hunger: u64, cleanliness: u64, mood: u64, level: u64) : (u64,u64,u64,u64) {
        let consume_time_m = consume_time / Minute;
        if (hunger > consume_time_m * 2) {
            hunger = hunger - consume_time_m * 2;
        } else {
            hunger = 0;
        };

        if (cleanliness > consume_time_m * 3) {
            cleanliness = cleanliness - consume_time_m * 3;
        }else {
            cleanliness = 0;
        };

        if (mood > consume_time_m * 1) {
            mood = mood - consume_time_m * 1;
        } else {
            mood = 0;
        };

        level = level + consume_time / Hour;
        return (hunger,cleanliness,mood,level)
    }

    // ============================================ View Functions ============================================

    public fun get_pet_state_and_level(world: &World, pet_id: vector<u8> , clock: &Clock) : (vector<u8>,u64,u64,u64,u64) {
        let (state , last_update_time) = state_component::get(world,pet_id);
        let (hunger , cleanliness , mood ,level) = level_component::get(world, pet_id);

        let current_time = clock::timestamp_ms(clock);
        let consume_time = current_time - last_update_time;

        let (current_hunger , current_cleanliness, current_mood, current_level) =
        if (state == b"online") {
            online_rule(consume_time, hunger , cleanliness , mood ,level)
        } else {
            (hunger , cleanliness , mood ,level)
        };
        (state , current_hunger , current_cleanliness, current_mood, current_level)
    }
}
