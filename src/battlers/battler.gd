extends Node2D
class_name Battler

@export var stats:BattlerStats
@export var ai_scene :PackedScene
@export var actions:Array[ActionData]
@export var is_party_member:= true
var acted:bool = false
var is_active:bool = true

signal selection_toggled(value)
signal damage_taken(amount)
signal action_finished
signal hit_missed

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
	assert(stats is BattlerStats)
	stats = stats.duplicate()
	#stats.reinitalize()
	stats.health_depleted.connect(_on_BattlerStats_health_depleted)

func _on_BattlerStats_health_depleted():
#    set_is_active(false)
	if not is_party_member: is_selectable = false

func _take_damage(amount:int) -> void:
	stats.health -= amount
	prints("took",amount,"damage, health is now",stats.health)

func act(action:Action) -> void:
	#if not is_player_controlled():
		##skip checking energy

	#energy won't be stored in indivisual party members
	##stats.energy -= action.get_energy_cost()
	await action.apply_async()
	#if is_active: 
		#set_process(true)
	action_finished.emit()

func turn_ended():
	stats.tick_modifiers()
	# also get hit by status effects or somthing idk