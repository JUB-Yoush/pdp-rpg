extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(new_value)


@export var max_health:int

# An array of elements against which the battler is weak.
# These weaknesses should be values from our `Types.Elements` enum.
@export var name:String
@export var portrait:Texture
@export var weaknesses := []
# The battler's elemental affinity. Gives bonuses with related actions.
@export var affinity = Types.Elements.NONE

var energy = {
	Types.ColorCost.RE:0,
	Types.ColorCost.GR:0,
}

var shield_points:int

var health := max_health:
	set(new_value):
		health = clamp(new_value,0,max_health)
		health_changed.emit(health)
		if health == 0:health_depleted.emit()
	get:
		return health
		

@export var base_attack := 10:
	set(new_value):
			base_attack = new_value
			_recalculate_and_update("attack")
	get:
			return base_attack

@export var base_defence := 10:
	set(new_value):
			base_defence = new_value
			_recalculate_and_update("defence")
	get:
			return base_defence

@export var base_speed := 10:
	set(new_value):
			base_speed = new_value
			_recalculate_and_update("speed")
	get:
			return base_speed

@export var base_hit_chance := 10:
	set(new_value):
			base_hit_chance = new_value
			_recalculate_and_update("hit_chance")
	get:
			return base_hit_chance

@export var base_evasion := 10:
	set(new_value):
			base_evasion = new_value
			_recalculate_and_update("evasion")
	get:
			return base_evasion

var attack := base_attack
var defence := base_defence
var speed := base_speed
var hit_chance := base_hit_chance
var evasion := base_evasion


const UPGRADABLE_STATS :Array[String]= ["max_health","max_energy","attack",
"defence","speed","hit_chance","evasion"]

var _modifiers := {}
var modifer_timing_tracker :Array[StatModifier]= []
func _init() -> void:
	health = max_health
	for stat in UPGRADABLE_STATS:
			_modifiers[stat] = {}

func _recalculate_and_update(stat:String):
		var value:float = get("base_" + stat)
		var modifiers: Array = _modifiers[stat].values()
		for modifier in modifiers:
				value += modifier._value
		value = max(value,0.0)
		set(stat,value)

# add a modifier to a stat (an positive or negative value that get's consdiered in it's final version)
func add_modifier(stat_name:String,value:float,length:int) -> int:
		assert(stat_name in UPGRADABLE_STATS, "Trying to add a modifier to a nonexistent stat.")
		var id:= _generate_unique_id(stat_name)
		_modifiers[stat_name][id] = StatModifier.new(stat_name,id,value,length)
		_modifiers[stat_name][id].modifier_over.connect(remove_modifier)
		modifer_timing_tracker.append(_modifiers[stat_name][id])
		_recalculate_and_update(stat_name)
		print("modified " , stat_name ," by ", str(value))
		return id

func remove_modifier(modifier:StatModifier)-> void:
		assert(modifier._id in _modifiers[modifier._stat_name], "Id %s not found in %s" % [modifier._id, _modifiers[modifier._stat_name]])
		print(modifier._value, " change to ", modifier._stat_name ," expried")
		_modifiers[modifier._stat_name].erase(modifier._id)
		_recalculate_and_update(modifier._stat_name)
		modifer_timing_tracker.erase([modifer_timing_tracker.find(modifier)])
		

# make id for a stat modifier 
func _generate_unique_id(stat_name:String) -> int:
		var keys:Array = _modifiers[stat_name].keys()
		# start at 0 overwise start at the most recent value
		if keys.is_empty():
				return 0
		else:
				return keys.back() + 1

func tick_modifiers():
		for modifier in modifer_timing_tracker:
				modifier.decrement()
