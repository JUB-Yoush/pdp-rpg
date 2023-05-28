extends Action
class_name HealAction


# We must override the constructor to use it.
# Notice how _init() uses a unique notation to call the parent's constructor.
func _init(data: HealActionData, actor:Battler, targets: Array):
	super(data, actor, targets)


## Returns the damage dealt by this action. We will update this function
## when we implement status effects.
func calculate_potential_heal_for(target:Battler) -> int:
	return Formulas.calulate_heal_amount(_data, _actor, target)


func apply_async() -> bool:
	# We apply the action to each target so attacks work both for single and multiple targets.
	for target in _targets:
		var hit_chance := Formulas.calculate_hit_chance(_data, _actor, target)
		var heal_amount:= calculate_potential_heal_for(target)
		# We're going to define a new function on the battler so it takes hits.
		#make some cast class or somthing that you can use for 
		target.recover_hp(heal_amount)
	# Our method is supposed to be a coroutine, that is to say, it pauses
	# execution and ends after some time.
	# in Godot 3.2, we do so using the `yield` keyword.
	# Here, we wait for the next frame by listening to the SceneTree's
	# `idle_frame` signal.
	await Engine.get_main_loop().process_frame
	return true