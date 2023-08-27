extends Node2D


enum STATES {PUZZLE,TURN}
var _state = STATES.TURN
var _party_members :Array[Battler]= []
var _opponents :Array[Battler]= []
var enemy_display_delay: =1.0
enum TYPE {RE,BL,GR,YE,PR,EM}

#manage points, timer, and state transitions 
var puzzle_points = {
		TYPE.RE:0,
		TYPE.BL:0,
		TYPE.GR:0,
		TYPE.YE:0,
		TYPE.PR:0}:
		set(new_value):
			puzzle_points = new_value
			update_point_display()
		get:
			return puzzle_points

var grid:Grid 
var battler_selecting = false
@onready var puzzleGame := $PuzzleGame
@onready var battlers := $Battlers.get_children()
@onready var screenwipe := get_parent().get_node("Screenwipe")
@onready var puzzlePointContainer := get_parent().get_node("UI/PuzzlePointContainer")
var UI:Control
var partyBoxes:VBoxContainer
var enemyBoxes:VBoxContainer

@onready var textBox:TextureRect = get_parent().get_node('UI/Textbox')

var UIActionMenuScene := preload("res://src/ui/ui_action_list.tscn")
var used_action_pieces :Array[ActionPiece] 

func _ready() -> void:
	grid = puzzleGame.get_node("Grid")
	grid.topped_out.connect(func (): screenwipe.activate("topped out! \n thanks for playing \n press r to restart"))
	UI = get_parent().get_node("UI")
	puzzleGame.done_puzzling.connect(end_puzzle)
	battle_start()

func _play_turn(battler:Battler):
	# this is where the battler would pick thier action and target
	# hard coding interaction for now
	#print(battler.stats.health)
	battler.turn_start()
	print("play turn")
	while !battler.turn_ended:
		check_for_winner()
		var actionData :ActionData = await _player_select_action_async(battler)
		var targets :Array[Battler]= await _player_select_targets_async(actionData,_opponents)
		var action:= ActionFactory.new_action(actionData,battler,targets)
		
		battler.act(action)
		await battler.action_finished
		
func battle_start():
	# make battler portraits
	partyBoxes = UI.get_node('PartyBoxes')
	enemyBoxes = UI.get_node('EnemyBoxes')

	for battler in battlers:
		if battler.is_party_member:
			_party_members.append(battler)
			partyBoxes.make_battler_box(battler)
		else:
			_opponents.append(battler)
			enemyBoxes.make_battler_box(battler)
	
	start_puzzle()



	
func end_turn():
	print("rpg phase over")
	textBox.visible = false
	#for battler in battlers: battler.turn_end()
	_state = STATES.PUZZLE
	start_puzzle()


func start_puzzle():
	puzzleGame.visible = true
	var _active_opponents :Array[Battler]= []
	for opp in _opponents:
		if opp.is_active: _active_opponents.append(opp)
	make_opponent_actions(_active_opponents)
	puzzleGame.start_puzzling(used_action_pieces)



func make_opponent_actions(_active_opponents:Array[Battler]):
	#loop thru every opponent and...
	var action_array :Array[Action]= []
	for opp in _active_opponents:
		#pick random acttoin
		var actionData :ActionData = opp.actions[randi_range(0,opp.actions.size()-1)]
		var targets :Array[Battler]= pick_party_targets(actionData)
		var action:= ActionFactory.new_action(actionData,opp,targets)
		action_array.append(action)
	#might be better to route thru puzzle game node
	grid.add_rows_with_actions(_active_opponents.size(),action_array)

func pick_party_targets(actionData:ActionData) -> Array[Battler]:
	# returns random target
	var targets:Array[Battler]=[]
	if actionData.is_targeting_self:targets = _opponents
	else: targets = _party_members
	if actionData.is_targeting_all: return targets
	else: return [targets[randi_range(0,targets.size()-1)]]
		
	

func end_puzzle(new_puzzle_points,ready_action_pieces:Array[ActionPiece]):
	# passed in is a dictonary of all points made from the puzzle phase as well as actions to call before the player can act
	_state = STATES.TURN
	puzzleGame.visible = false
	puzzle_points = new_puzzle_points
	start_turn(ready_action_pieces)

func update_point_display(): 
	print('update_point_display')
	puzzlePointContainer.get_node("RE").text = str(puzzle_points[TYPE.RE])
	puzzlePointContainer.get_node("BL").text = str(puzzle_points[TYPE.BL])
	puzzlePointContainer.get_node("GR").text = str(puzzle_points[TYPE.GR])

func start_enemy_turn(ready_action_pieces:Array[ActionPiece]):
	used_action_pieces = []
	for actionPiece in ready_action_pieces:
		var enemy:Battler = actionPiece.action._actor
		# if the enemy died after placing an action just remove the piece
		if !enemy.is_active:
			actionPiece.action_preformed.emit()
			used_action_pieces.append(actionPiece)
			continue
		await display_enemy_action(actionPiece.action)
		## if enemy can act
		enemy.act(actionPiece.action)
		await enemy.action_finished
		actionPiece.action_preformed.emit()
		enemy.turn_end()
		used_action_pieces.append(actionPiece)

func display_enemy_action(action:Action):
	var battler = action._actor
	for box in enemyBoxes.get_children():
		if box.battler == battler:
			var actionDisplay = box.get_node("ActionDisplay")
			actionDisplay.visible = true
			# fill in button data based on action
			actionDisplay.get_node("HBoxContainer/Label").text = action._data.label
			actionDisplay.get_node("HBoxContainer/Icon").texture = action._data.icon
			
			await get_tree().create_timer(enemy_display_delay).timeout
			actionDisplay.visible = false
			break


func start_turn(enemy_action_pieces):
	textBox.visible = true
	give_shield_points()
	check_for_winner()
	await start_enemy_turn(enemy_action_pieces)
	start_party_turn()

func check_for_winner():
	var out_battlers = 0
	for battler in _party_members:
		if !battler.is_active:
			out_battlers += 1
	if out_battlers == _party_members.size():
		party_lost()

	out_battlers = 0
	for battler in _opponents:
		if !battler.is_active:
			out_battlers += 1
	if out_battlers == _opponents.size():
		party_won()

func give_shield_points():
	for battler in _party_members:
		battler.stats.shield_points = puzzle_points[TYPE.BL]

func start_party_turn():
	for battler in _party_members:
		if !battler.is_active:
			continue
		_play_turn(battler)
		await battler.turn_passed
		if UI.get_node("UIActionMenu") != null:
			UI.remove_child(UI.get_node("UIActionMenu"))
	end_turn()

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
	battler_selecting = true
	#get relevant group of nodes
	var selectable_targets :UIBattlerBoxMenu = partyBoxes if _action.is_targeting_self else enemyBoxes
	if _action.is_targeting_all:
			return await _all_target_selection(selectable_targets)

	selectable_targets.setup()
	var selected_targets :Battler = await selectable_targets.target_selected
	print(selected_targets)
	var targets :Array[Battler] = []
	targets.append(selected_targets)
	print("target(s) chosen is ", selected_targets)
	selectable_targets.shutdown()
	return targets

func _all_target_selection(targetBoxes:UIBattlerBoxMenu):
	var targets:Array[Battler] = []
	targetBoxes.grab_all()
	for targetBox in targetBoxes.get_children():
		if targetBox.battler.is_active:
			targets.append(targetBox.battler)
	# get first active battler
	var index = 0
	while !targetBoxes.get_child(index).battler.is_active:
		index += 1
	await targetBoxes.get_child(index).pressed
	targetBoxes.ungrab_all()
	return targets

func party_lost():
	screenwipe.activate("party lost! \n press R to restart \n thanks for playing")

func party_won():
	screenwipe.activate("party won! \n press R to restart \n thanks for playing")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("end_turn"):
		end_turn()
	if event.is_action_pressed('restart'):
		get_tree().change_scene_to_file('res://src/combat_demo.tscn')
