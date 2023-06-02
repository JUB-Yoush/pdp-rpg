extends UIActionButton
class_name UIPassButton

signal pass_button_pressed

func _on_pressed() -> void:
    release_focus()
    pass_button_pressed.emit()
    