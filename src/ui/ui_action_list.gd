extends VBoxContainer

signal action_selected(action)

const UIActionButton:PackedScene = preload("res://src/ui/ui_action_button.tscn")

var buttons := []

var is_disabled := false:
    set(new_value):
        is_disabled = new_value
        for button in buttons:
            button.disabled = is_disabled
    get:
        return is_disabled

func setup(battler:Battler) -> void:
    # loops through the battlers avalable actions
    for action in battler.actions:
        var can_use_action:bool = battler.stats.energy >= action.energy_cost
        var actionButton = UIActionButton.instantiate()
        add_child(actionButton)
        actionButton.setup(action,can_use_action)
        #actionButton.pressed.connect()