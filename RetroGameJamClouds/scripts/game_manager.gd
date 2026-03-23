extends Node

var score = 0
var p_control = true
var rain_cloud = true
var acid_cloud = false
var lightening_cloud = false

func add_point():
	score += 1
	print("score: ", score)

func change_p_control(value):
	p_control = value
	print("controlling player: ", p_control)
	

func get_p_control():
	return p_control

func set_rain():
	rain_cloud = true
	acid_cloud = false
	lightening_cloud = false

func set_acid():
	rain_cloud = false
	acid_cloud = true
	lightening_cloud = false

func set_lightening():
	rain_cloud = false
	acid_cloud = false
	lightening_cloud = true

func next_level():
	pass
