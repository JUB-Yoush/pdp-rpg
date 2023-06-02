class_name ActionData
extends Resource

enum Elements {NONE,ROCK,PAPER,SCISSORS}
enum ActionType {ATTACK,HEAL,MODIFIER}


@export var icon: Texture
@export var label: = "action placeholder text"
@export var description: = "10 RED: This is what this action does."
var is_turn_ender:bool = false

@export var element: Elements

# set based on inherited action type
var type:ActionType

@export var color_cost:Dictionary = {
	Types.ColorCost.RE:0,
	Types.ColorCost.GR:0
}

var color_used:Types.ColorCost

@export var countdown_time = 1

@export var is_targeting_self := false
@export var is_targeting_all := false

func can_be_used_by(battler:Battler) -> bool:
	prints(color_cost[color_used],battler.stats.energy[color_used])
	return color_cost[color_used] <= battler.stats.energy[color_used]




