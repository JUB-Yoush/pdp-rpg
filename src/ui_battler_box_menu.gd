extends VBoxContainer
class_name UIBattlerBoxMenu

signal target_selected(targets)

var BattleBoxScene :PackedScene = preload("res://src/ui/ui_battler_box.tscn")

var button_index:int = 0
var is_disabled:= true
var grabbing_all := false

@onready var textbox := get_parent().get_node("Textbox")

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
	if is_disabled:return
	target_selected.emit(target)
	pass

func _on_UIBattlerBox_focus_entered(battleBox:UIBattlerBox):
	if is_disabled:return
	battleBox.grab_focus()
	pass

func focus() -> void:
	get_child(0).grab_focus()

func shutdown():
	for battleBox in get_children():
		battleBox.pressed.disconnect(_on_UIBattlerBox_target_selected.bind(battleBox.battler))
		battleBox.focus_entered.disconnect(_on_UIBattlerBox_focus_entered.bind(battleBox))
		deactivate()

func activate():
	is_disabled = false
	pass


func deactivate():
	is_disabled = true
	pass


func grab_all():
	grabbing_all = true
	activate()
	for battleBox in get_children():
		if !battleBox.battler.is_active:continue
		battleBox.texture_normal = load(battleBox.focused_border)
		battleBox.display_focus()
	textbox.update_text("All Enemies")
	var index = 0
	focus()	
	# get first active battler
	while !get_child(index).battler.is_active:
		index += 1
	get_child(index).grab_focus()

func ungrab_all():
	grabbing_all = false
	for battleBox in get_children():
		if !battleBox.battler.is_active:continue
		battleBox.texture_normal = load(battleBox.unfocused_border)
		battleBox.display_unfocus()
	deactivate()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and !is_disabled and !grabbing_all:
		button_index = max(0,button_index -1)
		focus_on_battleBox(get_child(button_index))
		

	if event.is_action_pressed("down") and !is_disabled and !grabbing_all:
		button_index = min(get_child_count()-1,button_index +1)
		focus_on_battleBox(get_child(button_index))


func focus_on_battleBox(battleBox:UIBattlerBox):
	battleBox.grab_focus()
	textbox.update_text(battleBox.battler.stats.name)
	pass
