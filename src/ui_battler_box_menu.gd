extends VBoxContainer
class_name UIBattlerBoxMenu

signal target_selected(targets)

var BattleBoxScene :PackedScene = preload("res://src/ui/ui_battler_box.tscn")

var button_index:int = 0
var is_disabled:= true
func make_battler_box(battler:Battler):
	var battlerBox :UIBattlerBox = BattleBoxScene.instantiate()
	battlerBox.setup(battler)
	add_child(battlerBox)

func setup():
	for battleBox in get_children():
		battleBox.pressed.connect(_on_UIBattlerBox_target_selected.bind(battleBox.battler))
		battleBox.focus_entered.connect(_on_UIBattlerBox_focus_entered.bind(battleBox))
		activate()
		focus()

func _on_UIBattlerBox_target_selected(target:Battler):
	target_selected.emit([target])
	pass

func _on_UIBattlerBox_focus_entered(battleBox:UIBattlerBox):
	battleBox.grab_focus()
	pass

func focus() -> void:
	get_child(0).grab_focus()

func activate():
	is_disabled = false
	pass


func deactivate():
	is_disabled = true
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and !is_disabled:
		button_index = max(0,button_index -1)
		get_child(button_index).grab_focus()

	if event.is_action_pressed("down") and !is_disabled:
		button_index = min(get_child_count()-1,button_index +1)
		get_child(button_index).grab_focus()
