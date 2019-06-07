extends Node2D

var selected = false
var type = null
var exits = []
var scale_dest = Vector2(0.0625, 0.0625)
var label_current = 0
var label_dest = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var sprite = get_node("Sprite")
	var label = get_node("CenterContainer/Label")
	sprite.scale = sprite.scale.linear_interpolate(scale_dest, min(delta * 4, 1.0))
	if label_current < label_dest:
		label_current += delta * 16
	else:
		label_current = label_dest
	label.visible_characters = floor(label_current)

func add_exit(node):
	if exits.find(node) == -1:
		exits.append(node)
	if node.exits.find(self) == -1:
		node.exits.append(self)

func set_terrain(t, tdict):
	type = t
	var sprite = get_node("Sprite")
	sprite.texture = tdict['image']
	sprite.self_modulate = tdict['color']
	set_label(t.capitalize())

func set_label(text):
	var label = get_node("CenterContainer/Label")
	label.text = text

func _on_mouse_entered():
	selected = true
	scale_dest = Vector2(0.125, 0.125)
	label_dest = 128

func _on_mouse_exited():
	selected = false
	scale_dest = Vector2(0.0625, 0.0625)
	label_dest = 0

func _input(event):
	if selected and event.is_action_pressed("left_click"):
		if Player.location.exits.find(self) > -1:
			Player.location = self
			Player.emit_signal("player_moved")
