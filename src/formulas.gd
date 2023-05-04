class_name Formulas

# Returns the product of the attacker's attack and the action's multiplier.
static func calculate_potential_damage(action_data, attacker) -> float:
    return attacker.stats.attack * action_data.damage_multiplier

# The base damage is "attacker.attack * action.multiplier - defender.defense".
# The function multiplies it by a weakness multiplier, calculated by
# `_calculate_weakness_multiplier` below. Finally, we ensure the value is an
# integer in the [1, 999] range.
static func calulate_base_damage(action_data,attacker,defender) ->int:
    var damage: float = calculate_potential_damage(action_data, attacker)
    damage -= defender.stats.defense
    damage *= _calculate_weakness_multiplier(action_data, defender)
    return int(clamp(damage, 1.0, 999.0))

static func calculate_hit_chance(action_data, attacker, defender) -> float:
    var chance: float = attacker.stats.hit_chance - defender.stats.evasion
    chance *= action_data.hit_chance / 100.0

    var element: int = action_data.element
    if element == attacker.stats.affinity:
        chance += 5.0
    if element != Types.Elements.NONE:
        if Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
            chance += 10.0
        if Types.WEAKNESS_MAPPING[defender.stats.affinity] == element:
            chance -= 10.0
    return clamp(chance, 0.0, 100.0)


# Calculates a multiplier based on the action and the defender's elements.
static func _calculate_weakness_multiplier(action_data, defender) -> float:
    var multiplier := 1.0
    var element: int = action_data.element
    if element != Types.Elements.NONE:
        # If the defender has an affinity with the action's element, the
        # multiplier should be 0.75
        if Types.WEAKNESS_MAPPING[defender.stats.affinity] == element:
            multiplier = 0.75
        # If the action's element is part of the defender's weaknesses, we
        # set the multiplier to 1.5
        elif Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
            multiplier = 1.5
    return multiplier