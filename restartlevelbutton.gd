extends Button


func _on_pressed() -> void:
	PlayerStats.damage_health(-1)
	get_tree().change_scene_to_file("res://Level1.tscn")
