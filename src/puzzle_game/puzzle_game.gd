extends Node2D
class_name PuzzleGame

#manage points, timer, and state transitions 
var puzzle_points = {
	"red":0,
	"green":0,
	"blue":0,
	"yellow":0}

var is_puzzling = true
var puzzle_time = 10.0

signal done_puzzling(puzzle_points,ready_action_pieces)

@onready var puzzleTimer := $PuzzleTimer
@onready var grid:Grid = $Grid

func _ready() -> void:
	puzzleTimer.timeout.connect(puzzle_timer_timeout)

func start_puzzling() -> void:
	is_puzzling = true
	puzzleTimer.start(puzzle_time)
	#make the grid visible and movable or whatever
	pass

func puzzle_timer_timeout():
	var ready_action_pieces = tick_action_pieces()
	done_puzzling.emit(puzzle_points,ready_action_pieces)

func tick_action_pieces() -> Array[ActionPiece]:
	var action_pieces:Array[ActionPiece] = grid.collect_action_pieces()
	var ready_action_pieces :Array[ActionPiece]= []
	for actionPiece in action_pieces:
		actionPiece.tick_countdown()
		if actionPiece.countdown_time == 0:
			ready_action_pieces.append(actionPiece)
			grid.action_countdown_finished(actionPiece)
	return ready_action_pieces


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tick_countdown"):
		tick_action_pieces()
	if event.is_action_pressed("puzzle_timeout"):
		puzzle_timer_timeout()
