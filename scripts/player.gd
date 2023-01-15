extends KinematicBody2D

var   vel:Vector2 = Vector2()
const scene_up:Vector2 = Vector2(0, -1)
const max_speed:int = 150
const gravity:int = 1000
const accel:int = 70
const jump_height:int = 320 # 350
var   direction:int = 1
var   hasInputs:bool = true
var 	tile_id:int;
enum {IDLE, WALK, JUMP, FALL}
var state:int = IDLE
var play_sound:bool = false
var sprint_scene:PackedScene = preload("res://scenes/sprint.tscn")

func _ready() -> void:
	randomize()
	$timer.connect("timeout", self, "_timer_timeout")

func _physics_process(delta) -> void:
	if hasInputs:
		movement_loop()
		state_loop()

		# contraindre le player aux limites de l'ecran
		var demi_tile = GLOBAL.tile_size / 2
		global_position.x = clamp(global_position.x, demi_tile, get_viewport().size.x - demi_tile)
		global_position.y = clamp(global_position.y, demi_tile, get_viewport().size.y - demi_tile)

		# claim :)
		if global_position.x <= demi_tile && Input.is_action_pressed("ui_left") && GLOBAL.scene_name != "title":
			$claim.visible = true
			$claim/anim.play("change_text")
		else:
			$claim.visible = false


		vel.y += gravity * delta
		vel = move_and_slide(vel, scene_up)
		var s = sprint_scene.instance()
		var side = -1 if $sprite.flip_h else 1
		s.position = self.position + Vector2(-10*side,0)

		self.get_parent().add_child_below_node(self.get_parent().get_node("env"), s)
		
		if get_parent().has_node("env"):
			if state == WALK && is_on_floor():
				var env = get_parent().get_node("env")
				tile_id = env.get_cellv(env.world_to_map(position + Vector2(0,16)))

	
				if tile_id == 8: # stones
					GLOBAL.get_node("sfx/sfx_walk_sand").stop()
					if !GLOBAL.get_node("sfx/sfx_walk_stone").is_playing():
						GLOBAL.get_node("sfx/sfx_walk_stone").play()
				else:
					GLOBAL.get_node("sfx/sfx_walk_stone").stop()
					if !GLOBAL.get_node("sfx/sfx_walk_sand").is_playing():
						GLOBAL.get_node("sfx/sfx_walk_sand").play()

func movement_loop() -> void:
	var left  = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump  = Input.is_action_just_pressed("ui_up")

	direction = int(right) - int(left)

	if direction == -1:
		vel.x = max(vel.x - accel, -max_speed)
		$sprite.flip_h = !GLOBAL.infinite_mode
	elif direction == 1:
		vel.x = min(vel.x + accel, max_speed)
		$sprite.flip_h = false
	else:
		vel.x = 0 #lerp(vel.x, 0, 0.15)

	if jump and is_on_floor():
		vel.y -= jump_height if !GLOBAL.infinite_mode else jump_height * 1.4

func state_loop() -> void:
	if state != WALK:
		GLOBAL.get_node("sfx/sfx_walk_sand").stop()
		GLOBAL.get_node("sfx/sfx_walk_stone").stop()

	if state == IDLE and vel.x != 0:
		change_state(WALK)
	if state == WALK and vel.x == 0:
		change_state(IDLE)
	if state in [IDLE, WALK] and !is_on_floor():
		change_state(JUMP)
		var rand = (randi() % 2) + 1 # pour que ce soit entre 1 et 2
		if play_sound:
			GLOBAL.get_node("sfx/sfx_jump"+str(rand)).play()
	if state == JUMP and vel.y > 0 and !is_on_floor():
		change_state(FALL)
	if state in [JUMP, FALL] and is_on_floor():
		change_state(IDLE)
		if play_sound:
			GLOBAL.get_node("sfx/sfx_fall").play()

func change_state(new_state) -> void:
	state = new_state
	match state:
		IDLE: 
			if !GLOBAL.infinite_mode: anim_play("idle")
			else: anim_play("walk_right")
		WALK:
			if direction == 1:
				anim_play("walk_right")
			else:
				if !GLOBAL.infinite_mode: anim_play("walk_left")
				else: anim_play("walk_right")
		JUMP:
			if direction == 1:
				anim_play("jump_right")
			elif direction == -1:
				if !GLOBAL.infinite_mode: anim_play("jump_left")
				else: anim_play("jump_right")
			else:
				if !GLOBAL.infinite_mode: anim_play("jump_idle")
				else: anim_play("jump_right")
		FALL:
			if direction == 1:
				anim_play("fall_right")
			elif direction == -1:
				if !GLOBAL.infinite_mode: anim_play("fall_left")
			else:
				if !GLOBAL.infinite_mode: anim_play("idle")
				else: anim_play("walk_right")

func anim_play(new_animation) -> void:
	if $anim.current_animation != new_animation:
		$anim.play(new_animation)

func freeze() -> void:
	hasInputs = false

func _timer_timeout() -> void:
	play_sound = true
