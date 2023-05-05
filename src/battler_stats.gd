extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(old_value,new_value)


@export var max_health := 20

# An array of elements against which the battler is weak.
# These weaknesses should be values from our `Types.Elements` enum.
@export var weaknesses := []
# The battler's elemental affinity. Gives bonuses with related actions.
@export var affinity = Types.Elements

var health := max_health:
    set(new_value):
        var old_health := health
        health = clamp(new_value,0,max_health)
        health_changed.emit(old_health,health)
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
            return base_defence

@export var base_hit_chance := 10:
    set(new_value):
            base_speed = new_value
            _recalculate_and_update("hit_chance")
    get:
            return base_defence

@export var base_evasion := 10:
    set(new_value):
            base_speed = new_value
            _recalculate_and_update("evasion")
    get:
            return base_defence


const UPGRADABLE_STATS :Array[String]= ["max_health","max_energy","attack",
"defence","speed","hit_chance","evasion"]

var _modifiers := {}
func _init() -> void:
        for stat in UPGRADABLE_STATS:
                _modifiers[stat] = {}

func _recalculate_and_update(stat:String):
        var value: float = get("base_" + stat)
        var modifiers: Array = _modifiers[stat].values()
        for modifier in modifiers:
                value += modifier
        value = max(value,0.0)
        set(stat,value)

# add a modifier to a stat (an positive or negative value that get's consdiered in it's final version)
func add_modifier(stat_name:String,value:float) -> int:
        assert(stat_name in UPGRADABLE_STATS, "Trying to add a modifier to a nonexistent stat.")
        var id:= _generate_unique_id(stat_name)
        _modifiers[stat_name][id] = value
        _recalculate_and_update(stat_name)
        return id

func remove_modifier(stat_name:String,id:int)-> void:
        assert(id in _modifiers[stat_name], "Id %s not found in %s" % [id, _modifiers[stat_name]])
        _modifiers[stat_name].erase(id)
        _recalculate_and_update(stat_name)
        

# make id for a stat modifier 
func _generate_unique_id(stat_name:String) -> int:
        var keys:Array = _modifiers[stat_name].keys()
        # start at 0 overwise start at the most recent value
        if keys.is_empty():
                return 0
        else:
                return keys.back() + 1