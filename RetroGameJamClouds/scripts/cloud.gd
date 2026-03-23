extends CharacterBody2D

@onready var game_manager = %GameManager

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast = $RayCast2D
@onready var rain_placement = $CollisionShape2D

const RAIN = preload("res://scenes/rain.tscn")
const ACID = preload("res://scenes/acid.tscn")
const LIGHTENING = preload("res://scenes/lightening.tscn")

const SPEED = 100
var direction = 0

func _physics_process(_delta):
	
	# Play animation
	if game_manager.rain_cloud:
		animated_sprite.play("idle_rain")
	elif game_manager.acid_cloud:
		animated_sprite.play("idle_acid")
	elif game_manager.lightening_cloud:
		animated_sprite.play("idle_lightening")
	
	# Listen for inputs only if the cloud is controlled
	if !game_manager.get_p_control():
		
		# Handle player/cloud swap
		if Input.is_action_just_pressed("control_player"):
			game_manager.change_p_control(true)
		
		# Handle cloud movement
		move_cloud()
		
		#Handle cloud action
		if Input.is_action_just_pressed("jump"):
			if game_manager.rain_cloud && !ray_cast.is_colliding():
				var rain = RAIN.instantiate()
				rain.global_position = rain_placement.global_position + Vector2(0,20)
				add_sibling(rain)
				rain.get_node("AnimatedSprite2D").play("default")
				rain.get_node("AnimatedSprite2D2").play("default")
				await rain.get_node("AnimatedSprite2D").animation_finished
				rain.queue_free()
			elif game_manager.acid_cloud && !ray_cast.is_colliding():
				var acid = ACID.instantiate()
				acid.global_position = rain_placement.global_position + Vector2(0,20)
				add_sibling(acid)
				acid.get_node("AnimatedSprite2D").play("default")
				acid.get_node("AnimatedSprite2D2").play("default")
				await acid.get_node("AnimatedSprite2D").animation_finished
				acid.queue_free()
			elif game_manager.lightening_cloud && !ray_cast.is_colliding():
				var lightening = LIGHTENING.instantiate()
				lightening.global_position = rain_placement.global_position + Vector2(0,20)
				add_sibling(lightening)
				lightening.get_node("AnimatedSprite2D").play("default")
				lightening.get_node("AnimatedSprite2D2").play("default")
				await lightening.get_node("AnimatedSprite2D").animation_finished
				lightening.queue_free()
			
			if ray_cast.is_colliding():
				var obj = ray_cast.get_collider()
				var body_animated_sprite = obj.get_child(0)
				if(obj.is_in_group("fire") && game_manager.rain_cloud):
					var rain = RAIN.instantiate()
					rain.global_position = rain_placement.global_position + Vector2(0,20)
					add_sibling(rain)
					rain.get_node("AnimatedSprite2D").play("default")
					rain.get_node("AnimatedSprite2D2").play("default")
					body_animated_sprite.play("remove_fire")
					await body_animated_sprite.animation_finished
					rain.queue_free()
					obj.queue_free()
				if(obj.is_in_group("beam") && game_manager.acid_cloud):
					var acid = ACID.instantiate()
					acid.global_position = rain_placement.global_position + Vector2(0,20)
					add_sibling(acid)
					acid.get_node("AnimatedSprite2D").play("default")
					acid.get_node("AnimatedSprite2D2").play("default")
					body_animated_sprite.play("melt")
					await body_animated_sprite.animation_finished
					obj.queue_free()
					acid.queue_free()
				if(obj.is_in_group("rod") && game_manager.lightening_cloud):
					var lightening = LIGHTENING.instantiate()
					lightening.global_position = rain_placement.global_position + Vector2(0,20)
					add_sibling(lightening)
					lightening.get_node("AnimatedSprite2D").play("default")
					lightening.get_node("AnimatedSprite2D2").play("default")
					body_animated_sprite.play("powered")
					await lightening.get_node("AnimatedSprite2D").animation_finished
					lightening.queue_free()
		

# Listens for input and moves cloud accordingly
func move_cloud():
	direction = Input.get_axis("move_left", "move_right")
	
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
