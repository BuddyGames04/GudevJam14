extends Area2D

# Points awarded when the coin is collected
@export var points: int = 10  # Use @export in Godot 4

func _ready():
	# Optional: Start a floating animation
	if $AnimationPlayer:
		$AnimationPlayer.play("Coin")

func _on_Coin_body_entered(body):
	# Check if the player collided with the coin
	if body.name == "Player":  # Ensure it's the player
		PlayerStats.add_score(points)  # Add points to the global score
		queue_free()  # Remove the coin
