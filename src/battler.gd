extends Node2D
class_name Battler

@export var stats:Resource
@export var ai_scene :PackedScene
@export var actions:Array[Action]
@export var is_party_member:= true
var acted:bool = false

signal selection_toggled(value)

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

func _on_BattlerStats_health_depleted():
    #set_is_active(false)
    if not is_party_member: is_selectable = false