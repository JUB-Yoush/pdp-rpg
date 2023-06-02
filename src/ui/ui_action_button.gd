extends TextureButton
class_name UIActionButton
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

func _ready() -> void:
	pressed.connect(_on_pressed)

#unfocus when pressed
func _on_pressed() -> void:
	release_focus()
