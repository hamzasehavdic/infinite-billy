extends CharacterBody2D

const MOVE_SPEED = 30

var player_nearby: bool = false
var can_fireball: bool = true

var health = 2

var FireballScene = preload("res://scenes/projectiles/fireball.tscn")


func hit():
	var tween = create_tween()
	health -= 1

	# show as hit
	tween.tween_property($AnimatedSprite2D, "self_modulate", Color.RED, 0.05)
	$Timers/HitTimer.start()
	$HitSound.play()
	
	if health <= 0:
		set_process_internal(false)
		tween.tween_property($AnimatedSprite2D, "self_modulate", Color.BLACK, 0.05)
		tween.tween_property($AnimatedSprite2D, "self_modulate:a", 0, 0.1)
		await tween.finished
		queue_free()

		Globals.kill_amount += 1


func _process(_delta):
	if player_nearby and can_fireball:
		var marker_node = $FireballSpawnPositions.get_child(0)
		can_fireball = false

		var fireball = FireballScene.instantiate()

		fireball.global_position = marker_node.global_position
		fireball.dir_vec = (Globals.player_pos - global_position).normalized()
		fireball.rotation = (fireball.dir_vec).angle()
		
		var projectiles_node = get_parent().get_parent().get_child(3)
		projectiles_node.add_child(fireball)
		$Timers/FireballTimer.start()

	velocity = (Globals.player_pos - global_position).normalized() * MOVE_SPEED
	move_and_slide()


func _on_attack_area_body_entered(body):
	player_nearby = true
	var dir = global_position.direction_to(body.global_position)
	scale.x = -1 if dir.x < 0 else 1 

func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_fireball_timer_timeout():
	can_fireball = true


func _on_hit_timer_timeout():
	$AnimatedSprite2D.self_modulate = Color.WHITE
