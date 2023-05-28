class_name ActionData
extends Resource

enum Elements {NONE,ROCK,PAPER,SCISSORS}
enum ActionType {ATTACK,HEAL,MODIFIER}
enum ColorCost {RE,GR}

@export var icon: Texture
@export var label: = "action placeholder text"

@export var energy_cost:= 0

@export var element: Elements

var type:ActionType

@export var color_cost:ColorCost

@export var countdown_time = 1

@export var is_targeting_self := false
@export var is_targeting_all := false

func can_be_used_by(battler) -> bool:
    return energy_cost <= battler.stats.energy




