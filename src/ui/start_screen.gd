extends Control


func _input(event: InputEvent) -> void:
    if event.is_action_pressed('restart'):
        get_tree().change_scene_to_file('res://src/combat_demo.tscn')
