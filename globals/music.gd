extends Node

var songs: Array = ['res://audio/fight_chiptune_1.wav','res://audio/fight_chiptune_2.mp3']

func _ready() -> void:
	$AudioStreamPlayer.stream = load(songs[1])
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	var choice = randi_range(0, 1)
	$AudioStreamPlayer.stream = load(songs[choice])
	$AudioStreamPlayer.play()
	
