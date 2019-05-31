extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_texture(resource):
	get_node("Sprite").texture = resource
	self.position.x = randi() % 1024
	self.position.y = randi() % 600
