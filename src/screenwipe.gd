extends TextureRect

@onready var label:Label = $Label

func activate(msg:String):
    get_tree().paused = true
    label.text = msg
    pass