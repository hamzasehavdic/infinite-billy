extends CharacterBody2D

var move_speed = 60

var player_nearby: bool = false
var ExplosionScene = preload('res://scenes/projectiles/explosion.tscn')

@onready var can_atk: bool = true

var health = 1

func _process(_delta):
	velocity = (Globals.player_pos - global_position).normalized() * move_speed
	move_and_slide()


func hit():
	var tween = create_tween()
	health -= 1

	# show as hit
	tween.tween_property($Sprite2D, "self_modulate", Color.RED, 0.05)
	$Timers/HitTimer.start()
	$HitSound.play()
	
	if health <= 0:
		detonate()
		Globals.kill_amount += 1


func detonate() -> void:
		set_process_input(false)
		velocity = Vector2.ZERO
		var explosion = ExplosionScene.instantiate()
		explosion.global_position = global_position
		$'../../Projectiles'.add_child(explosion)
		queue_free()


func _on_attack_area_body_entered(body):
		detonate()


func _on_detect_area_body_entered(body: Node2D) -> void:
	$DetonateSound.play()
	player_nearby = true
	var dir = global_position.direction_to(body.global_position)
	scale.x = -1 if dir.x < 0 else 1
	move_speed *= 2


func _on_detect_area_body_exited(body: Node2D) -> void:
	player_nearby = false
	move_speed /= 2


func _on_hit_timer_timeout():
	$AnimatedSprite2D.self_modulate = Color.WHITE

