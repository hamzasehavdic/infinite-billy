extends Node2D

var spawn_ready: bool


func _init() -> void:
	spawn_ready = true


func _process(_delta) -> void:
	if spawn_ready: 
		spawn_ready = false
		var enemy_pod = $SpawnPods.get_child(randi() % $SpawnPods.get_child_count())
		enemy_pod.spawn_enemy()
		$SpawnTimer.start()


func _on_spawn_timer_timeout():
	spawn_ready = true
