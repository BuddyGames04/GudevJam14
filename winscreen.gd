extends Control

# The integer you want to display
#Test


# Reference to the Label node
@onready var label = $Label3

func _ready():
	# Set the initial value of the label
	update_label()

func update_label():
	# Update the label text to display the integer
	label.text = str(PlayerStats.score)

# Example: Increment the score and update the label
func _process(delta: float) -> void:
	update_label()
