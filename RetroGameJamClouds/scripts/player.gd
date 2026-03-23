extends CharacterBody2D

@onready var game_manager = %GameManager

@onready var camera_2d = $Camera2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var direction = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	camera_2d.limit_left = -50

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Get input only if player is controlled
	if game_manager.get_p_control():
		# Handle player swap
		if Input.is_action_just_pressed("control_cloud"):
			game_manager.change_p_control(false)
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction
		direction = Input.get_axis("move_left", "move_right")
	else:
		direction = 0
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0 && game_manager.rain_cloud:
			animated_sprite.play("idle_rain")
		elif direction == 0 && game_manager.acid_cloud:
			animated_sprite.play("idle_acid")
		elif direction == 0 && game_manager.lightening_cloud:
			animated_sprite.play("idle_lightening")
		else:
			if game_manager.rain_cloud:
				animated_sprite.play("run_rain")
			elif game_manager.acid_cloud:
				animated_sprite.play("run_acid")
			elif game_manager.lightening_cloud:
				animated_sprite.play("run_lightening")
	else:
		if game_manager.rain_cloud:
				animated_sprite.play("jump_rain")
		elif game_manager.acid_cloud:
				animated_sprite.play("jump_acid")
		elif game_manager.lightening_cloud:
				animated_sprite.play("jump_lightening")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
