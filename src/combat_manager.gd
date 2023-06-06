extends Node2D

"""
the loop:
start by playing pdp for like 10 seconds
clear lines and collect points
after that, display the points at the top of the screen or somthing
display all potential actions in a list
when an action is selected, go to selection the target
when turn is ended (button to press or somthing): go back to pdp

need a state system to manage if we're playing the puzzle game or not
party members are stored in an array and thier turns are called

"""

enum STATES {PUZZLE,TURN}
var _state = STATES.TURN
var _party_members :Array[Battler]= []
var _opponents :Array[Battler]= []
enum TYPE {RE,BL,GR,YE,PR,EM}
#manage points, timer, and state transitions 
var puzzle_points = {
		TYPE.RE:50,
		TYPE.BL:0,
		TYPE.GR:50,
		TYPE.YE:0,
		TYPE.PR:0}
var grid:Grid 
@onready var puzzleGame := $PuzzleGame
@onready var battlers := $Battlers.get_children()
var UI
var UIActionMenuScene = preload("res://src/ui/ui_action_list.tscn")
var used_action_pieces :Array[ActionPiece] 

func _ready() -> void:
	grid = puzzleGame.get_node("Grid")
	UI = get_parent().get_node("UI")
	puzzleGame.done_puzzling.connect(end_puzzle)
	battle_start()
	end_turn()
	#_play_turn(_party_members[0])

func _play_turn(battler:Battler):
	# this is where the battler would pick thier action and target
	# hard coding interaction for now
	#print(battler.stats.health)
	battler.turn_start()
	print("play turn")
	while !battler.turn_ended:
		
		var targets :Array[Battler]= [_opponents[0]]
		var actionData :ActionData = await _player_select_action_async(battler)

		var action:= ActionFactory.new_action(actionData,battler,targets)
		
		battler.act(action)
		await battler.action_finished
	
func battle_start():
	# make battler portraits
	for battler in battlers:
		if battler.is_party_member:
			_party_members.append(battler)
		else:
			_opponents.append(battler)
	pass	

	
func end_turn():
	print("rpg phase over")
	#for battler in battlers: battler.turn_end()
	_state = STATES.PUZZLE
	start_puzzle()


func start_puzzle():
	puzzleGame.visible = true
	var _active_opponents :Array[Battler]= [_opponents[0]]
	make_opponent_actions(_active_opponents)
	puzzleGame.start_puzzling(used_action_pieces)



func make_opponent_actions(_active_opponents:Array[Battler]):
	#loop thru every opponent and...
	var battler :Battler = _active_opponents[0] #hard code for testing
	var targets :Array[Battler]= [_party_members[0]] #hard coded
	var actionData :ActionData = battler.actions[0]
	var action:= ActionFactory.new_action(actionData,battler,targets)
	var action_array :Array[Action]= [action]
	#might be better to route thru puzzle game node
	grid.add_rows_with_actions(_active_opponents.size(),action_array)

func end_puzzle(new_puzzle_points,ready_action_pieces:Array[ActionPiece]):
	# passed in is a dictonary of all points made from the puzzle phase as well as actions to call before the player can act
	_state = STATES.TURN
	puzzleGame.visible = false
	puzzle_points = new_puzzle_points
	start_turn(ready_action_pieces)

func start_enemy_turn(ready_action_pieces:Array[ActionPiece]):
	used_action_pieces = []
	for actionPiece in ready_action_pieces:
		var enemy:Battler = actionPiece.action._actor
		## if enemy can act
		enemy.act(actionPiece.action)
		await enemy.action_finished
		actionPiece.action_preformed.emit()
		enemy.turn_end()
		used_action_pieces.append(actionPiece)

func start_turn(enemy_action_pieces):
	start_enemy_turn(enemy_action_pieces)
	start_party_turn()

	#loop thru enemies and put in speed-sorted array
	# play turn for each purple counted down

	# loop through all our party members
	# sort them by speed stat
	# play_turn for each of them
	# at end of loop go back to puzzle ig
	pass

func start_party_turn():
	for battler in _party_members:
		if !battler.is_active:
			continue
		_play_turn(battler)
		await battler.turn_passed
		if UI.get_node("UIActionMenu") != null:
			UI.remove_child(UI.get_node("UIActionMenu"))
			pass
	#print('okay all done loop')
				
				
		
	# loop through all our party members
	# sort them by speed stat
	# play_turn for each of them
	# at end of loop go back to puzzle ig
	end_turn()


	pass

func _player_select_action_async(battler) -> ActionData:
	var actionMenu:UIActionMenu = UIActionMenuScene.instantiate()
	UI.add_child(actionMenu)
	actionMenu.setup(battler)
	actionMenu.focus()
	var action_data:ActionData = await actionMenu.action_selected
	print("action chosen is ", action_data.label)
	actionMenu.queue_free()
	return action_data

func _player_select_targets_async(_action:ActionData,opponents:Array[Battler]) -> Array[Battler]:
	return []


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("end_turn"):
		end_turn()
