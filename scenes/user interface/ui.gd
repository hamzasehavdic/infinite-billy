
extends CanvasLayer

@onready var kill_amount_label: Label = $StatsControl/GridContainer/KillsAmount

func _ready():
	Globals.connect("kills_incremented", _on_kills_incremented)
	update_kill_amount_text()
	
	Globals.connect("player_health_changed", _on_player_health_changed)



func _on_kills_incremented(new_kill_amount: int):
	update_kill_amount_text()

func update_kill_amount_text():
	kill_amount_label.text = str(Globals.kill_amount)

func _on_player_health_changed(new_health: int):
	update_health_bar()
	
func update_health_bar() -> void:
	$StatsControl/LifeHBoxContainer.remove_child($StatsControl/LifeHBoxContainer.get_child(0))
	
