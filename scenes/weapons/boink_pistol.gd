extends Sprite2D


# imports
var blue_bullet_scene = preload("res://scenes/projectiles/blue_bullet.tscn")


# independent/primitive vars
@export var cd_duration_sec = 1.0
var can_action: bool

# dependent/node vars
var cd_timer: Timer
@onready var muzzle: Marker2D = $MuzzleMarker2D


func _init():
	can_action = true


func _ready():
	# setup reload timers
	cd_timer = Timer.new()
	cd_timer.wait_time = cd_duration_sec
	cd_timer.one_shot = true
	add_child(cd_timer)
	cd_timer.timeout.connect(_on_cd_timer_timeout)


func action(dir_vec: Vector2) -> void:
	var projectile = blue_bullet_scene.instantiate()
	projectile.global_position = muzzle.global_position
	projectile.dir_vec = dir_vec
	add_child(projectile)

	can_action = false
	self_modulate = Color.RED
	cd_timer.start()


func _on_cd_timer_timeout() -> void:
	can_action = true
	self_modulate = Color.WHITE

