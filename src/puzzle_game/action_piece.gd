extends Piece

var countdown_time:int
var action_stored:Action
signal countdown_finished

func tick_countdown():
	countdown_time-=1
	if countdown_time == -1:
		countdown_finished.emit(action_stored)

