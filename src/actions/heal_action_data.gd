extends ActionData
class_name HealActionData

# heals you for 25% of your HP
@export_range(0,1.0) var recovery_multiplier

func _init() -> void:
    type = ActionType.HEAL