class_name ActionData
extends Resource

enum Elements {NONE,ROCK,PAPER,SCISSORS}
enum ActionType {ACTIVE,PASSIVE}

@export var icon: Texture
@export var label: = "combat action placeholder text"

@export var energy_cost:= 0

@export var element: Elements

@export var action_type:ActionType

@export var is_targeting_self := false
@export var is_targeting_all := false

func can_be_used_by(battler) -> bool:
    return energy_cost <= battler.stats.energy




