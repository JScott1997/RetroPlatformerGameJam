extends Node

var score = 0
var p_control = true

func add_point():
	score += 1
	print("score: ", score)

func change_p_control(value):
	p_control = value
	print("controlling player: ", p_control)
	

func get_p_control():
	return p_control
