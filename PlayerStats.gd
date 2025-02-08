extends Node

# Public score variable
var score: int = 0

# Function to increment the score
func add_score(amount: int) -> void:
	score += amount
	print("Score:", score)
