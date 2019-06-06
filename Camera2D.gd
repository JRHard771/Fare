extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ex_curve(vector):
	vector.x = sign(vector.x) * range_lerp(abs(vector.x), 0, 512, 0, abs(vector.x))
	vector.y = sign(vector.y) * range_lerp(abs(vector.y), 0, 300, 0, abs(vector.y))
	return vector

func _process(delta):
	if Input.get_mouse_button_mask():
		var mpos = get_local_mouse_position()
		position.x += mpos.x * delta
		position.y += mpos.y * delta * (512 / 300)

func _input(event):
	var vinny = get_node("Vignette")
	if event.is_action_pressed("zoom_in"):
		zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed("zoom_out"):
		zoom += Vector2(0.15, 0.15)
	if zoom.x < 0.3:
		zoom = Vector2(0.3, 0.3)
	zoom = zoom.clamped(3.0)
	vinny.scale = zoom