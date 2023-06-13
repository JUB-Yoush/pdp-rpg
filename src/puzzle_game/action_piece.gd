extends Piece
#stores enemy action inside it and put's it in the grid
class_name ActionPiece
var countdown_time:int
var action:Action
@onready var label = $Sprite/CountdownLabel
signal action_preformed

func _init() -> void:
	is_action_piece = true

func _ready() -> void:
	label.text = str(countdown_time)

func tick_countdown():
	countdown_time -= 1
	label.text = str(countdown_time)


