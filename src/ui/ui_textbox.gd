extends TextureRect

@onready var label:Label= $Label

func update_text(new_text:String):
    label.text = new_text

