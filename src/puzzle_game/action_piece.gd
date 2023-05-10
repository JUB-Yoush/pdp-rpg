extends Piece
class_name ActionPiece
var countdown_time:int
var action:Action
@onready var label = $Sprite/CountdownLabel
signal countdown_finished

func _init() -> void:
	is_action_piece = true

func _ready() -> void:
	label.text = str(countdown_time)

func tick_countdown():
	countdown_time -= 1
	label.text = str(countdown_time)
	if countdown_time == 0:
		countdown_finished.emit(self)


