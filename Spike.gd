extends Area2D

func _on_body_entered(body: Node2D) -> void:
	PlayerStats.damage_health(1)
	print("collider")
