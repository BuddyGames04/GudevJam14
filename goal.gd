extends Area2D

# Points awarded when the coin is collected	
@export var targetScene : String

func _ready() -> void:
	position = Vector2(1416, -248) 


func _on_body_entered(body: Node2D) -> void:
	print("Fuck")
	get_tree().change_scene_to_file(targetScene)
