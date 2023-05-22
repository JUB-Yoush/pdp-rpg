extends Node2D
class_name PuzzleGame

enum TYPE {RE,BL,GR,YE,PR,EM}
#manage points, timer, and state transitions 
var puzzle_points = {
		TYPE.RE:0,
		TYPE.BL:0,
		TYPE.GR:0,
		TYPE.YE:0,
		TYPE.PR:0}

var is_puzzling = true
var puzzle_time = 10.0

signal done_puzzling(puzzle_points,ready_action_pieces)

@onready var puzzleTimer := $PuzzleTimer
@onready var destroyTimer := $DestoryTimer
@onready var collapseTimer := $CollapseTimer
@onready var grid:Grid = $Grid
@onready var puzzlePointContainer := $PuzzlePointContainer


func _ready() -> void:
	puzzleTimer.timeout.connect(puzzle_timer_timeout)
	grid.cleared_lines.connect(add_puzzle_points)

func start_puzzling() -> void:
	is_puzzling = true
	puzzleTimer.start(puzzle_time)
	#make the grid visible and movable or whatever
	pass

func puzzle_timer_timeout():
	## we need to make sure there are no more matches being destroyed or cleared
	# when we add a combo system this will be simple enough?
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

func add_puzzle_points(added_puzzle_points:Dictionary):
	if added_puzzle_points.values() == [0,0,0,0,0]:
		return
	print(added_puzzle_points)
	for key in added_puzzle_points.keys():
		puzzle_points[key] += added_puzzle_points[key]
	update_point_display()

func update_point_display():
	puzzlePointContainer.get_node("RE").text = "RE:" + str(puzzle_points[TYPE.RE])
	puzzlePointContainer.get_node("BL").text = "BL:" + str(puzzle_points[TYPE.BL])
	puzzlePointContainer.get_node("GR").text = "GR:" + str(puzzle_points[TYPE.GR])
	puzzlePointContainer.get_node("YE").text = "YE:" + str(puzzle_points[TYPE.YE])
	#puzzlePointContainer.get_node("PR").text = "PR:" + str(puzzle_points[TYPE.PR])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tick_countdown"):
		tick_action_pieces()
	if event.is_action_pressed("puzzle_timeout"):
		puzzle_timer_timeout()
