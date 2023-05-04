class_name Hit

# The damage dealt by the hit.
var damage := 0
# Chance to hit in base 100.
var hit_chance: float


func _init(_damage: int, _hit_chance := 100.0) -> void:
    damage = _damage
    hit_chance = _hit_chance


# Returns true if the hit isn't missing. To use when consuming the hit.
func does_hit() -> bool:
    return randf() * 100.0 < hit_chance