extends Node2D


var enemy

func spawn_enemy() -> void:
	$AnimatedSprite2D.play("right_ready")
	
	var rolled_int = randi_range(1, 10)
	if rolled_int < 3:
		enemy = (load('res://scenes/enemies/enemy_fire_droid.tscn')).instantiate()
	else:
		enemy = (load('res://scenes/enemies/enemy_bomb_droid.tscn')).instantiate()
	
	enemy.global_position = $Marker2D.global_position
	$'../../Enemies'.add_child(enemy) 

	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("right_charging")
