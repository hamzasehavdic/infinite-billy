extends Node

signal kills_incremented(new_kill_amount)
signal player_position_changed(new_position)
signal player_health_changed(new_health)

var player_pos: Vector2:
	set(value):
		if player_pos != value:
			player_pos = value
			emit_signal("player_position_changed", player_pos)

var kill_amount: int = 0:
	set(value):
		if kill_amount != value:
			kill_amount = value
			emit_signal("kills_incremented", kill_amount)

var player_health: int = 3:
	set(value):
		if player_health != value:
			player_health = value
			emit_signal("player_health_changed", player_health)
