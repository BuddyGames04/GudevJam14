extends StaticBody2D

@export var health: int = 1  # Number of hits required to break

# Access the child Area2D for punch detection
@onready var punch_area = $Area2D

func _ready():
	# Ensure the CollisionShape2D is enabled
	$CollisionShape2D.disabled = false
	print("BreakableWall ready with collision enabled")
	
	# Connect the Area2D's signal for punch detection
	punch_area.connect("area_entered", Callable(self, " _on_breakable_wall_area_entered"))

func take_damage():
	health -= 1
	if health <= 0:
		break_wall()

func break_wall():
	# Disable the wall's collision and hide visuals
	$CollisionShape2D.disabled = true  # Disable the StaticBody2D's collision
	$Sprite2D.hide()  # Hide the sprite
	punch_area.queue_free()  # Remove the Area2D
	queue_free()  # Remove the StaticBody2D after animations if needed


func _on_breakable_wall_area_entered(area: Area2D) -> void:
	if area.name == "PunchArea":  # Ensure it's Sunny's punch area
		take_damage()
