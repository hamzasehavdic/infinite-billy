class_name BlueBullet
extends Area2D

@export var speed: int = 1000
var shoot_vec: Vector2

var sd_timer: Timer
var sprite: Sprite2D
var coll_shape: CollisionShape2D

func _init(dir_vec: Vector2):
	shoot_vec = dir_vec * speed

func _ready():
	

	.start()


func _process(delta):
	position += shoot_vec * delta


func _on_body_entered(body):
	queue_free()


func _on_sd_timer_timeout():
	queue_free()
