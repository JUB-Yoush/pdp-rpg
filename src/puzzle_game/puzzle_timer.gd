extends Timer
class_name PuzzleTimer

var max_time = 10

@onready var label := $Label
@onready var progressBar := $ProgressBar


func _ready() -> void:
	progressBar.max_value = max_time
	one_shot = true
	#timeout.connect(timeout_func) ## make sure collapse/destroy timer isn't running when you timeout


func _physics_process(delta: float) -> void:
	if !is_stopped():
		label.text = "%.1f" % time_left
		progressBar.value = time_left


func add_time(extra_time: float):
	max_time = time_left + extra_time
	progressBar.max_value = int(time_left + 1)
	start(max_time)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_time"):
		add_time(1.0)
	if event.is_action_pressed("pause"):
		paused = !paused

#func timeout_func():
