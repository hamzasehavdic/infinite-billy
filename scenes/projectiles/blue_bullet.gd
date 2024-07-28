extends Area2D


const LIFE_DURATION = 2.0
@export var speed: int = 500
@export var dir_vec: Vector2 = Vector2.RIGHT


var vel: Vector2
var sd_timer: Timer


func _ready():
	vel = speed * dir_vec

	# setup reload timers
	sd_timer = Timer.new()
	sd_timer.wait_time = LIFE_DURATION
	sd_timer.one_shot = true
	add_child(sd_timer)
	sd_timer.timeout.connect(_on_sd_timer_timeout)
	sd_timer.start()


func _process(delta):
	print(position)
	position += vel * delta


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	queue_free()


func _on_sd_timer_timeout():
	queue_free()
