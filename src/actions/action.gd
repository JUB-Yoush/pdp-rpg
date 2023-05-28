class_name Action

signal finished


var _data
var _actor:Battler
var _targets := []

    

func _init(data:ActionData,actor:Battler,targets) -> void:
    _data = data
    _actor = actor
    _targets = targets

# Applies the action on the targets, using the actor's stats.
# Returns `true` if the action succeeded.
#
# Notice that the function's name includes the suffix "async".
# This indicates the function should be a coroutine (it should use yield()).
# That's because in our case, finishing an action involves animation.

func apply_async() -> bool:
    await Engine.get_main_loop().process_frame
    finished.emit()
    return true

# Returns `true` if the action should target opponents by default.
func targets_opponents() -> bool:
    return true

func get_energy_cost() -> int:
    return _data.energy_cost


