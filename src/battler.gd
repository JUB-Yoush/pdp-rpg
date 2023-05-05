extends Node2D
class_name Battler

@export var stats:Resource
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
	if hit.does_hit():
		_take_damage(hit.damage)
	else:
		hit_missed.emit()

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

func act(action:Action) -> void:
	stats.energy -= action.get_energy_cost()
	await action.apply_async()
	#if is_active: 
		#set_process(true)
	action_finished.emit()
