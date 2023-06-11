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
var puzzle_time = 15.0

signal done_puzzling(puzzle_points,ready_action_pieces)

@onready var puzzleTimer := $PuzzleTimer
@onready var destroyTimer := $DestoryTimer
@onready var collapseTimer := $CollapseTimer
@onready var grid:Grid = $Grid
@onready var puzzlePointContainer := get_parent().get_parent().get_node("UI/PuzzlePointContainer")


func _ready() -> void:
	puzzleTimer.timeout.connect(puzzle_timer_timeout)
	grid.cleared_lines.connect(add_puzzle_points)

func start_puzzling(used_action_pieces:Array[ActionPiece]) -> void:
	is_puzzling = true
	# if there's at least one action used last turn
	if used_action_pieces.size() > 0:
		rm_used_actions(used_action_pieces)
	puzzleTimer.start(puzzle_time)
	#make the grid visible and movable or whatever
	pass

func rm_used_actions(used_action_pieces:Array[ActionPiece]):
	for actionPiece in used_action_pieces:
		grid.change_to_empty(actionPiece.col,actionPiece.row)
		grid.collapseTimer.start(grid.cleardrop_delay)


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
	var extra_time :=0.0
	if added_puzzle_points.values() == [0,0,0,0,0]:
		return
	for key in added_puzzle_points.keys():
		# any pieces after 3 are worth x2
		var points:int = added_puzzle_points[key]
		if points == 0:continue
		var extra_points: = points - 3	
		points = 3 + (extra_points * 2)
		if key == TYPE.BL:points = int(points/2) + 1
		puzzle_points[key] += points
		if key == TYPE.YE:
			extra_time = float(points) / 2
			puzzleTimer.add_time(extra_time)

	update_point_display()

func update_point_display(): 
	print('update_point_display')
	puzzlePointContainer.get_node("RE").text = str(puzzle_points[TYPE.RE])
	puzzlePointContainer.get_node("BL").text = str(puzzle_points[TYPE.BL])
	puzzlePointContainer.get_node("GR").text = str(puzzle_points[TYPE.GR])

func exchange_time():
	if puzzleTimer.time_left > 5.0:
		grid.add_rows(1)
		puzzleTimer.add_time(-5.0)
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tick_countdown"):
		tick_action_pieces()
	if event.is_action_pressed("puzzle_timeout"):
		puzzle_timer_timeout()
	if event.is_action_pressed("exhange_time"):
		exchange_time()

