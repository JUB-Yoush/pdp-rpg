class_name StatModifier

var _stat_name:String
var _id:int
var _value:float
var _turns_remaining:int

signal modifier_over(value)

func _init(stat_name:String,id:int,value:float,turns_remaining:int) -> void:
    _stat_name = stat_name
    _id = id
    _value = value
    _turns_remaining = turns_remaining


func decrement():
    _turns_remaining -= 1
    if _turns_remaining == 0:
        modifier_over.emit(self)
