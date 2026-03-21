extends CharacterBody2D

@onready var game_manager = %GameManager

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 100
var direction = 0

func _physics_process(_delta):
	
	# Listen for inputs only if the cloud is controlled
	if !game_manager.get_p_control():
		
		# Handle player/cloud swap
		if Input.is_action_just_pressed("control_player"):
			game_manager.change_p_control(true)
		
		# Handle cloud movement
		move_cloud()
		
		#Handle cloud action
		if Input.is_action_just_pressed("jump"):
			pass

# Listens for input and moves cloud accordingly
func move_cloud():
	direction = Input.get_axis("move_left", "move_right")
	
	# Play animation
	if direction == 0:
			animated_sprite.play("idle")
	else:
		animated_sprite.play("movement")
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
