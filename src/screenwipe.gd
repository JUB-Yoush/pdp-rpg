extends TextureRect

@onready var label:Label = $Label

func activate(msg:String):
    visible = true
    get_tree().paused = true
    label.text = msg
    pass