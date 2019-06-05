extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.get_mouse_button_mask():
		var mpos = get_local_mouse_position()
		mpos.x /= 256.0
		mpos.y /= 150.0
		position.x += mpos.x * delta * 512
		position.y += mpos.y * delta * 512

func _input(event):
	var vinny = get_node("Vignette")
	if event.is_action_pressed("zoom_in"):
		zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed("zoom_out"):
		zoom += Vector2(0.05, 0.05)
	vinny.scale = zoom