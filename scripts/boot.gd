extends Node2D

func _ready() -> void:
	$boot.modulate = Color(1,1,1,0)
	$boot_sfx.play()
	$tween.interpolate_property($boot, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, 0)
	$tween.start()
	yield($tween, "tween_completed")


	$tween.interpolate_property($mask, "position", $mask.position, Vector2(288, 0), 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(.13), "timeout")

	$wink_sfx.play()
	yield(get_tree().create_timer(.02), "timeout")
	GLOBAL.next_scene("title")
