extends Node2D
class_name Piece
enum TYPE {RE,BL,GR,YE,EM}
var empty:bool 
var type:int
var swap_anim_time:float = .1
var can_swap:bool = true
var matched = false
var positon:Vector2i = Vector2.ZERO
@onready var sprite = $Sprite


func _ready() -> void:
	sprite.texture = load("res://assets/block-"+str(type)+".png")
	#match color:
		#COLORS.RE:
			#sprite.texture = load("res://assets/block-RED.png")
		#COLORS.BL:
			#sprite.texture = load("res://assets/block-BLUE.png")
		#COLORS.GR:
			#sprite.texture = load("res://assets/block-GREEN.png")
		#COLORS.PU:
			#sprite.texture = load("res://assets/block-PURPLE.png")
		#COLORS.YE:
			#sprite.texture = load("res://assets/block-YELLOW.png")

func move(new_pos:Vector2):
	var tween = create_tween()
	tween.tween_property(self,"position",new_pos,swap_anim_time)



func dim():
	sprite.modulate = Color(1,1,1,.5)

		