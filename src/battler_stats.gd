extends Resource
class_name BattlerStats

signal health_depleted
signal health_changed(old_value,new_value)


var max_health := 20

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


func _recalculate_and_update(stat:String):
    pass

