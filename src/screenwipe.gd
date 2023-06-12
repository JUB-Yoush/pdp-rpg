extends TextureRect

@onready var label:Label = $Label

func activate(msg:String):
	visible = true
	get_tree().paused = true
	label.text = msg
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

