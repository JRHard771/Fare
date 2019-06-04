extends Node2D

var node_from
var node_to

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var distance = node_from.position.distance_to(node_to.position)
	var dots = round(distance / 32)
	var step = node_from.position.direction_to(node_to.position) * (distance / dots)
	var pos = node_from.position + step
	for i in range(dots-1):
		draw_circle(pos, 4, Color(0,0,0))
		draw_circle(pos, 2, Color(1,1,1))
		pos += step
