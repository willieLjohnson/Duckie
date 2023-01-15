extends Path2D

export var speed:int = 2.5
export var value:int = 15

func _ready() -> void:
	tween_start()

	
func start(speed: float) -> void:
	speed = -speed
	$follow/kinematicBody2D.start(2)
	
func reset() -> void:
	speed = 0
	GLOBAL.score += value
	
func tween_start() -> void:
	$tween.interpolate_property($follow, "unit_offset", 0, 1, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _process(delta) -> void:
	$follow/kinematicBody2D/hit/sprite.rotation_degrees -= 15

func _on_platform_body_entered(body) -> void:
	if body.name == "player":
		GLOBAL.player_dead()
		GLOBAL.restart_scene()
