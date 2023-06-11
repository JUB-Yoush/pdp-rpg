extends VBoxContainer
class_name UIActionMenu

signal action_selected(action)

const UIActionButton:PackedScene = preload("res://src/ui/ui_action_button.tscn")
const UIPassButtonScene = preload("res://src/ui/ui_pass_button.tscn")

@onready var textbox := get_parent().get_node("Textbox")

var buttons := []
var button_index := 0
var active = false

var is_disabled := false:
	set(new_value):
		is_disabled = new_value
		for button in buttons:
			button.disabled = is_disabled
	get:
		return is_disabled


func setup(battler:Battler) -> void:
	# remove the sample actions
	for c in get_children():
		self.remove_child(c)
		c.queue_free()
	# add actions based on array
	for action in battler.actions:
		var can_use_action:bool = action.can_be_used_by(battler)
		var actionButton = UIActionButton.instantiate()
		add_child(actionButton)
		actionButton.setup(action,can_use_action)
		actionButton.pressed.connect(_on_UIActionButton_button_pressed.bind(action))
		actionButton.focus_entered.connect(_on_UIActionButton_focus_entered.bind(actionButton))
	# add option to end turn
	var UIPassButton:UIPassButton = UIPassButtonScene.instantiate() 
	UIPassButton.pass_button_pressed.connect(battler.turn_end)
	add_child(UIPassButton)
	buttons = get_children()

func _ready() -> void:
	var x_start = get_viewport_rect().size.x/2 - (134/2)
	var y_start = 75
	position = Vector2(x_start,y_start)

func focus() -> void:
	buttons[0].grab_focus()

func _on_UIActionButton_focus_entered(button:UIActionButton) -> void:
	pass
	#button.grab_focus()
	

func _on_UIActionButton_button_pressed(action: ActionData) -> void:
	is_disabled = false
	action_selected.emit(action)
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if is_disabled: return
		button_index = max(0,button_index -1)
		buttons[button_index].grab_focus()
		textbox.update_text(buttons[button_index].description)

	if event.is_action_pressed("down"):
		if is_disabled: return
		button_index = min(buttons.size()-1,button_index +1)
		buttons[button_index].grab_focus()
		textbox.update_text(buttons[button_index].description)
