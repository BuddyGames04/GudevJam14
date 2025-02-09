extends RigidBody2D

@onready var static_collision_shape = $StaticBody2D/CollisionShape2D2

func _process(delta):
	if PlayerStats.playerState:
		# Set the crate to Rigid mode and disable the static collision shape
		PhysicsServer2D.body_set_mode(get_rid(), PhysicsServer2D.BODY_MODE_RIGID)
		static_collision_shape.disabled = true
	else:
		# Set the crate to Static mode and enable the static collision shape
		PhysicsServer2D.body_set_mode(get_rid(), PhysicsServer2D.BODY_MODE_STATIC)
		static_collision_shape.disabled = false
