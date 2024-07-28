extends Node2D

func _ready() -> void:
	$AnimationPlayer.play('explode')


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	body.hit()
