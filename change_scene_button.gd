extends Button

@export var targetScene : String



func _on_button_up() -> void:
	get_tree().change_scene_to_file(targetScene)
