extends Area2D

@onready var game_manager = %GameManager

func _on_body_entered(body):
	# go to next level
	game_manager.next_level()
