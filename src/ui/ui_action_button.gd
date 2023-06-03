extends TextureButton
class_name UIActionButton

const focused_color := 'ffffeb'
const unfocued_color := '43434f'
const disabled_color := "c2c2d1"

const focused_icon := "res://assets/ui/action-icon-focused.png"
const unfocused_icon := "res://assets/ui/action-icon-unfocused.png"
const disabled_icon := "res://assets/ui/action-icon-disabled.png"

@onready var _icon_node:TextureRect = $HBoxContainer/Icon
@onready var _label_node:Label = $HBoxContainer/Label

func setup(action:ActionData,can_be_used:bool) -> void:
	# halt untill added to the tree (parent might call setup before you're in the tree)
	if not is_inside_tree():
		await self.ready

	# Only update the icon's texture if the action data inlcudes an icon.
	if action.icon:
		_icon_node.texture = action.icon
	_label_node.text = action.label

	#we will tell the button if the action can be used or not
	disabled = not can_be_used
	_label_node.modulate = disabled_color
	_icon_node.texture = load(disabled_icon)

func _ready() -> void:
	pressed.connect(_on_pressed)
	focus_entered.connect(display_focus)
	focus_exited.connect(display_unfocus)

#unfocus when pressed
func _on_pressed() -> void:
	release_focus()

func display_focus():
	if disabled == false:
		_label_node.modulate = focused_color
		_icon_node.texture = load(focused_icon)
		

func display_unfocus():
	if disabled == false:
		_label_node.modulate = unfocued_color
		_icon_node.texture = load(unfocused_icon)