extends CharacterBody2D

enum State {
	SUNNY_IDLE, SUNNY_MOVING, SUNNY_JUMPING, SUNNY_PUNCHING,
	GRIM_IDLE, GRIM_MOVING, GRIM_JUMPING, GRIM_WALL_JUMPING
}

# State and Form Variables
var current_state = State.SUNNY_IDLE
var is_sunny = true  # Tracks the active form
var sunny_collision 
var grim_collision 
# Movement Parameters
var gravity = 900  # Gravity strength
var speed = 200    # Default speed
var jump_force = -400  # Jump impulse
var sunny
var grim
var facing_right = true  # Tracks Sunny's facing direction

@onready var punch_area = $Sunny/PunchArea  # Area2D for Sunny's punches

func _ready():
	sunny = get_node("Sunny")
	grim = get_node("Grim")
	sunny_collision = $SunnyCollision
	grim_collision = $GrimCollision
	set_form(true)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when grounded

	# Handle movement and states
	match current_state:
		State.SUNNY_IDLE:
			process_idle(delta)
		State.SUNNY_MOVING:
			process_moving(delta)
		State.SUNNY_JUMPING:
			process_jumping(delta)
		State.SUNNY_PUNCHING:
			process_punching(delta)  # Handle punching state
		State.GRIM_IDLE:
			process_idle(delta)
		State.GRIM_MOVING:
			process_moving(delta)
		State.GRIM_JUMPING:
			process_jumping(delta)

	# Apply movement
	move_and_slide()

	if position.y >= 500:
		PlayerStats.damage_health(1)
		
	if PlayerStats.health <= 0:
		get_tree().change_scene_to_file("res://deathscreen.tscn")

	# Animations
	if not is_sunny:
		$Grim/AnimationPlayer.play("Idle")
	else:
		punch_area.position.x = 30 if facing_right else -30
		if is_on_floor() and current_state == State.SUNNY_MOVING:
			$Sunny/AnimationPlayer.play("Walk")
			$AudioStreamPlayer2D.play()
		elif current_state == State.SUNNY_IDLE:
			$Sunny/AnimationPlayer.play("Idle")
		elif not is_on_floor():
			$Sunny/AnimationPlayer.play("JumpFall") 
			

func process_idle(delta):
	# Move or jump based on input
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		current_state = State.SUNNY_MOVING if is_sunny else State.GRIM_MOVING

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force  # Apply jump force immediately
		current_state = State.SUNNY_JUMPING if is_sunny else State.GRIM_JUMPING

	if is_sunny and Input.is_action_just_pressed("punch"):  # Punch input
		current_state = State.SUNNY_PUNCHING
		start_punch()

func process_moving(delta):
	# Determine movement direction
	var direction = 0
	if Input.is_action_pressed("right"):
		direction += 1
		facing_right = true  # Update facing direction
	if Input.is_action_pressed("left"):
		direction -= 1
		facing_right = false  # Update facing direction

	velocity.x = direction * speed

	# Flip the sprite based on direction
	if direction > 0:
		if is_sunny:
			sunny.get_node("Sprite2D").flip_h = true
		else:
			grim.get_node("Sprite2D").flip_h = true
	elif direction < 0:
		if is_sunny:
			sunny.get_node("Sprite2D").flip_h = false
		else:
			grim.get_node("Sprite2D").flip_h = false

	# Update punch area position
	if is_sunny:
		$Sunny/PunchArea/CollisionShape2D.position.x = -15 if facing_right else 15

	# Return to idle if no movement
	if direction == 0:
		current_state = State.SUNNY_IDLE if is_sunny else State.GRIM_IDLE

	# Handle jumping directly from the moving state
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force  # Apply jump force immediately
		current_state = State.SUNNY_JUMPING if is_sunny else State.GRIM_JUMPING

	if is_sunny and Input.is_action_just_pressed("punch"):  # Punch input
		current_state = State.SUNNY_PUNCHING
		start_punch()

func process_jumping(delta):
	# Allow horizontal movement while jumping
	var direction = 0
	if Input.is_action_pressed("right"):
		direction += 1
	if Input.is_action_pressed("left"):
		direction -= 1

	velocity.x = direction * speed

	# Return to idle when landing
	if is_on_floor():
		current_state = State.SUNNY_IDLE if is_sunny else State.GRIM_IDLE

func process_punching(delta):
	# N/A
	pass 

func start_punch() -> void:
	punch_area.monitoring = true  # Enable punch detection
	$Sunny/AnimationPlayer.play("Punch")  # Play punch animation
	await get_tree().create_timer(0.8).timeout  # Punch lasts for 0.2 seconds
	
	punch_area.monitoring = false  # Disable punch detection
	current_state = State.SUNNY_IDLE



func _input(event):
	# Switch between Sunny and Grim
	if Input.is_action_just_pressed("switch_form"):
		set_form(not is_sunny)

func set_form(sunny_active):
	is_sunny = sunny_active

	# Enable or disable the collision shapes
	sunny_collision.disabled = not is_sunny
	grim_collision.disabled = is_sunny

	# Enable or disable the visuals
	sunny.visible = is_sunny
	grim.visible = not is_sunny

	# Update collision layers and masks
	if is_sunny:
		collision_layer = 3  # Big player layer
		collision_mask = 5   # Interact with crate
		speed = 100
		jump_force = -300
		PlayerStats.playerState = true
	else:
		collision_layer = 2  # Small player layer
		collision_mask = 5   # Interact with crate
		speed = 150
		jump_force = -400
		PlayerStats.playerState = false
