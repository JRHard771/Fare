extends Node2D

var neighbors = []
var current = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_texture(resource):
	var sprite = get_node("Sprite")
	sprite.texture = resource
	sprite.self_modulate = Color(randf()*0.9+0.1, randf()*0.9+0.1, randf()*0.9+0.1)
	self.position.x = randi() % 960 + 32
	self.position.y = randi() % 536 + 32

func add_neighbor(mapnode):
	neighbors.append(mapnode)
	mapnode.neighbors.append(self)

func _draw():
	if current:
		for n in neighbors:
			var step = self.position.direction_to(n.position).normalized() * 24.0
			var path_pos = Vector2(position.x + step.x, position.y + step.y)
			while path_pos.distance_to(n.position) >= 24.0:
				draw_circle(path_pos - position, 5, Color(0.0, 0.0, 0.0))
				draw_circle(path_pos - position, 3, Color(1.0, 1.0, 1.0))
				path_pos += step
