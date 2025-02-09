extends Area2D

@export var health: int = 1  # Number of hits required to break
@export var break_animation: NodePath = ""  # Optional animation or particles

func _on_BreakableWall_area_entered(area):
	if area.name == "PunchArea":  # Ensure it's Sunny's punch area
		take_damage()

func take_damage():
	health -= 1
	if health <= 0:
		break_wall()

func break_wall():

	queue_free()  # Remove the wall
