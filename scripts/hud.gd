extends Node2D

export var infiniteMode:bool = false
var time:float = 0

func _ready() -> void:
	get_tree().paused = false
	time = 0
	show_time()
	show_level()

	$timer.connect("timeout", self, "_on_timer_timeout")

	
func _process(delta):
	show_time()
	
func _on_timer_timeout() -> void:
	time += 0.01
	if infiniteMode:
		$level/label.text = str(GLOBAL.score)


func show_time() -> void:
	if infiniteMode:
		$time/label.text = GLOBAL.seconds2hhmmss(time)
	else:
		$time/label.text = GLOBAL.global_time()
	

func show_level() -> void:
	if !infiniteMode:
		$level/label.text = str(GLOBAL.level_index)+"/"+str(GLOBAL.level_max)
