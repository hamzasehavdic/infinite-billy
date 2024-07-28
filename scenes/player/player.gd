class_name Player
extends CharacterBody2D


const SPEED = 80

var vulnerable: bool = true

var BoinkPistolScene = preload("res://scenes/weapons/boink_pistol.tscn")
var primary_wep: Sprite2D
var secondary_wep: Sprite2D

var dir = (get_global_mouse_position() - global_position).normalized()


@onready var player_cam: Camera2D = $PlayerCamera2D
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var inf_cup = $InfiniteCup


func _ready():
	primary_wep = BoinkPistolScene.instantiate()
	secondary_wep = BoinkPistolScene.instantiate()
	setup_weapon(primary_wep, $FPrimaryWepMarker2D)
	setup_weapon(secondary_wep, $FSecondaryWepMarker2D)


func setup_weapon(weapon: Sprite2D, marker: Marker2D):
	weapon.global_position = marker.global_position
	weapon.z_as_relative = true
	add_child(weapon)


func handle_aim() -> void:
	var updated_z = 1 if dir.y > 0 else -1
	
	# orient weapons to mouse cursor
	for wep in [primary_wep, secondary_wep]:
		wep.rotation = dir.angle()
		wep.scale.y = -abs(wep.scale.y) if dir.x < 0 else abs(wep.scale.y)
		wep.z_index = updated_z

	# orbit cup around player
	var opposite_angle = primary_wep.rotation + PI
	var new_position = Vector2(
		cos(opposite_angle) * 20,
		sin(opposite_angle) * 20
	)
	inf_cup.position = new_position

	# connect lines to weps
	$Line2DL.points[0] = inf_cup.position + Vector2(-1,-4)
	$Line2DR.points[0] = inf_cup.position + Vector2(1,-4)

	if updated_z == 1:
		$Line2DL.points[1] = primary_wep.position
		$Line2DR.points[1] = secondary_wep.position
		primary_wep.global_position = $FPrimaryWepMarker2D.global_position
		secondary_wep.global_position = $FSecondaryWepMarker2D.global_position
	else:

		$Line2DL.points[1] = secondary_wep.position
		$Line2DR.points[1] = primary_wep.position
		primary_wep.global_position = $BPrimaryWepMarker2D.global_position
		secondary_wep.global_position = $BSecondaryWepMarker2D.global_position


func _process(_delta):
	dir = (get_global_mouse_position() - global_position).normalized()
	handle_aim()
	handle_movement()
	move_and_slide()

	Globals.player_pos = global_position



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and primary_wep.can_action:
			primary_wep.action(dir)
		elif event.button_index == MOUSE_BUTTON_RIGHT and secondary_wep.can_action:
			secondary_wep.action(dir)



func handle_movement() -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir:
		anim_sprite.play("BACKMOVE" if dir.y < 0 else "MOVE")
		velocity = SPEED * input_dir
	else:
		anim_sprite.play("BACKIDLE" if dir.y < 0 else "IDLE")
		velocity = Vector2.ZERO


func hit():
	var tween = create_tween()
	if vulnerable:
		Globals.player_health -= 1
		vulnerable = false

		tween.tween_property(anim_sprite, "self_modulate", Color.RED, 0.1)
		$Timers/HitTimer.start()
		$HitSound.play()
	if Globals.player_health <= 0:
		tween.tween_property(anim_sprite, "modulate", Color.BLACK, 0.1)
		tween.tween_property(anim_sprite, "modulate:a", 0, 0.5)
		await tween.finished
		queue_free()
		get_tree().change_scene_to_file('res://scenes/screens/play_menu.tscn')


func _on_hit_timer_timeout():
	vulnerable = true
	anim_sprite.self_modulate = Color.WHITE

