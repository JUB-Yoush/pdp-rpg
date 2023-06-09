extends Node2D
class_name Piece
enum TYPE {RE,BL,GR,YE,PR,EM}
var empty:bool 
var is_action_piece:bool = false
var type:int
var swap_anim_time:float = .1
var can_swap:bool = true
var matched = false
var col:int
var row:int
@onready var sprite = $Sprite


func _ready() -> void:
	sprite.texture = load("res://assets/block-"+str(type)+".png")
	if type == TYPE.EM:
		z_index = -100



func move(new_pos:Vector2):
	var tween = create_tween()
	tween.tween_property(self,"position",new_pos,swap_anim_time)



func dim():
	sprite.modulate = Color(1,1,1,.5)

		
