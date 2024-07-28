extends Node2D


func _on_area_2d_area_entered(area:Area2D):
	print(area)
	print()
	print(self)
	print(get_parent())
	print(get_parent().get_children())
	print(get_parent().get_child_count())

	for portal in get_parent().get_children():
		if self != portal:
			self.modulate = Color.ORANGE
			portal.modulate = Color.RED
			var portal_area: Area2D = portal.get_child(0)
			portal_area.monitoring = false

			area.global_position = portal.global_position
			area.modulate = Color.RED
			area.scale *= 2
			area.speed /= 2

			await get_tree().create_timer(2).timeout
			self.modulate = Color.WHITE
			portal.modulate = Color.WHITE
			portal_area.monitoring = true
