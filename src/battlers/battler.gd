extends Node2D
class_name Battler

@export var stats:BattlerStats
@export var ai_scene :PackedScene
@export var ui_data:BattlerUIData
@export var actions:Array[ActionData]
@export var is_party_member:= true
var acted:bool = false
var turn_ended:bool = false
var is_active:bool = true

signal selection_toggled(value)
signal damage_taken(amount)
signal action_finished
signal hit_missed
signal turn_passed

func take_hit(hit:Hit)-> void:
	print("taking hit")
	if hit.does_hit():
		_take_damage(hit.damage)
	else:
		print("missed")
		hit_missed.emit()

func recover_hp(amount):
	var old_hp = stats.health
	stats.health += amount
	prints("healed",amount, "from",old_hp, "health, health is now",stats.health)

var is_selected := false: 
	get:
		return is_selected
	set(value):
		is_selected = value

var is_selectable := true:
	set(new_value):
		if new_value: assert(is_selectable)
		is_selected = new_value
		selection_toggled.emit(is_selected)
	get:
		return(is_selectable)

func is_player_controlled() -> bool:
	return ai_scene == null
	
func _ready():
	seed(4)
	assert(stats is BattlerStats)
	#makes new instance of resource (so two glups don't share HP)
	stats = stats.duplicate()
	#stats.reinitalize()
	stats.health_depleted.connect(_on_BattlerStats_health_depleted)

func _on_BattlerStats_health_depleted():
	is_active = false
	if not is_party_member: is_selectable = false

func _take_damage(amount:int) -> void:
	stats.health -= amount
	prints("took",amount,"damage, health is now",stats.health)

func act(action:Action) -> void:
	print('battler doing an action!!!')
	if is_party_member:
		print("it's a party member too!?")
		remove_energy(action)
	await action.apply_async()
	#if is_active: 
		#set_process(true)
	action_finished.emit()

func turn_end(): # runs after a pm has manually ended turn
	print('MANUAL TURN ENDING LIKE GOD INTENDED')
	stats.tick_modifiers()

	# give back the puzzle points as we've modified them.
	var puzzle_points = get_parent().get_parent().puzzle_points
	puzzle_points[Types.ColorCost.RE] = stats.energy[Types.ColorCost.RE]
	puzzle_points[Types.ColorCost.GR] = stats.energy[Types.ColorCost.GR]
	get_parent().get_parent().puzzle_points = puzzle_points
	turn_passed.emit()
	turn_ended = true

func turn_start():
	var puzzle_points = get_parent().get_parent().puzzle_points
	print("battler puzzle points ",puzzle_points)
	stats.energy[Types.ColorCost.RE] = puzzle_points[Types.ColorCost.RE]
	stats.energy[Types.ColorCost.GR] = puzzle_points[Types.ColorCost.GR]
	turn_ended = false


func remove_energy(action:Action):
	#var cost = action.get_energy_cost()
	var color = action._data.color_used
	stats.energy[color] -= action._data.color_cost[color]
	
