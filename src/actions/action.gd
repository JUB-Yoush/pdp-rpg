class_name Action

signal finished


var _data:ActionData
var _actor:Battler
var _targets :Array[Battler]= []

    

func _init(data:ActionData,actor:Battler,targets) -> void:
    _data = data
    _actor = actor
    _targets = targets

    if _data.color_cost[Types.ColorCost.RE] > 0:
        _data.color_used = Types.ColorCost.RE
    elif _data.color_cost[Types.ColorCost.GR] > 0:
        _data.color_used = Types.ColorCost.GR
    else:
        _data.color_used = null

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
    # only one color or another, no fusion attacks yet.
    # one will be 0 and that's the one it dosen't use, 
    return max(_data.color_cost[Types.ColorCost.RE],_data.color_cost[Types.ColorCost.GR])

