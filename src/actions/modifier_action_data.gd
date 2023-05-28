extends ActionData
class_name ModifierActionData



const UPGRADABLE_STATS :Array[String]= ["max_health","max_energy","attack",
"defence","speed","hit_chance","evasion"]

@export var stat_name:String
@export var length:int
@export var value :float

func _init() -> void:
    type = ActionType.MODIFIER
