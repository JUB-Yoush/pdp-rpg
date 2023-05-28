class_name ActionFactory

enum ActionType {ATTACK,HEAL,MODIFIER}
static func new_action(action_data, actor, target) -> Action:
	match(action_data.type):
		ActionType.ATTACK:	
			return AttackAction.new(action_data, actor, target)
		ActionType.HEAL:
			return HealAction.new(action_data, actor, target)
		ActionType.MODIFIER:
			return ModifierAction.new(action_data, actor, target)
		_:
			return Action.new(action_data, actor, target)