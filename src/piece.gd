extends Node2D
class_name Piece
enum TYPE {RE,BL,GR,YE,PU}
var type:int
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
