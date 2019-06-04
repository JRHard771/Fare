extends Node2D

var type = null
var exits = []
var scale_dest = Vector2(0.0625, 0.0625)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var sprite = get_node("Sprite")
	sprite.scale = sprite.scale.linear_interpolate(scale_dest, min(delta * 4, 1.0))

func add_exit(node):
	if !exits.find(node):
		exits.append(node)
	if !node.exits.find(self):
		node.exits.append(self)

func set_texture(resource, set_scale=0.0625):
	var sprite = get_node("Sprite")
	sprite.texture = resource
	sprite.scale.x = set_scale
	sprite.scale.y = set_scale

func _on_mouse_entered():
	scale_dest = Vector2(0.125, 0.125)

func _on_mouse_exited():
	scale_dest = Vector2(0.0625, 0.0625)
