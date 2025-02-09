extends Node

# Public score variable
var score: int = 0
var health: int = 1
var level
var playerState: bool = true
# Function to increment the score
func add_score(amount: int) -> void:
	score += amount
	print("Score:", score)

func damage_health(amount:int) ->void:
	health -= amount
	
