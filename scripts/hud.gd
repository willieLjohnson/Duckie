extends Node2D

export var infiniteMode:bool = false
var time:float = 0

func _ready() -> void:
	
	get_tree().paused = false
	time = 0
	show_time()
	show_level()

	$timer.connect("timeout", self, "_on_timer_timeout")
func _on_timer_timeout() -> void:
	show_time()
	if infiniteMode:
		$level/label.text = str(GLOBAL.score)
		
func show_time() -> void:
	time += 0.01
	if infiniteMode:
		$time.text = str(time)
	else:
		GLOBAL.time += 0.01
		$time.text = str(GLOBAL.time)
	

func show_level() -> void:
	if !infiniteMode:
		$level/label.text = str(GLOBAL.level_index)+"/"+str(GLOBAL.level_max)

