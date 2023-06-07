extends VBoxContainer
class_name UIBattlerBoxMenu

signal target_selected(targets)

var BattleBoxScene :PackedScene = preload("res://src/ui/ui_battler_box.tscn")

func make_battler_box(battler:Battler):
    var battlerBox :UIBattlerBox = BattleBoxScene.instantiate()
    battlerBox.setup(battler)
    add_child(battlerBox)

func setup():
    for battleBox in get_children():
        battleBox.pressed.connect(_on_UIBattlerBox_target_selected.bind(battleBox.battler))
        battleBox.focused_entered.connect(_on_UIBattlerBox_focus_entered.bind(battleBox))

func _on_UIBattlerBox_target_selected(target:Battler):
    target_selected.emit([target])
    pass

func _on_UIBattlerBox_focus_entered(battleBox:UIBattlerBox):
    battleBox.grab_focus()
    pass

func focus() -> void:
    get_child(0).grab_focus()

func activate():
    pass


func deactivate():
    pass
