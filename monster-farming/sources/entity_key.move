module monster_farming::entity_key {
    use sui::object;
    use sui::hash::keccak256;

    public fun object_to_entity_key<T: key + store>(object: &T): vector<u8> {
        object::id_bytes(object)
    }

    public fun monster_to_entity_key(name: vector<u8>): vector<u8> {
        keccak256(&name)
    }
}