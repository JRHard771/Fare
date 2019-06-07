extends Camera2D

onready var dest = position
var zoom_dest = zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("player_moved", self, "go_to_player")

func ex_curve(vector):
	vector.x = sign(vector.x) * range_lerp(abs(vector.x), 0, 512, 0, abs(vector.x))
	vector.y = sign(vector.y) * range_lerp(abs(vector.y), 0, 300, 0, abs(vector.y))
	return vector

func _process(delta):
	var vinny = get_node("Vignette")
	position = position.linear_interpolate(dest, delta * 2)
	zoom = zoom.linear_interpolate(zoom_dest, delta * 2)
	vinny.scale = zoom

func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom_dest -= Vector2(0.1, 0.1)
	if event.is_action_pressed("zoom_out"):
		zoom_dest += Vector2(0.15, 0.15)
	if zoom_dest.x < 0.3:
		zoom_dest = Vector2(0.3, 0.3)
	zoom_dest = zoom_dest.clamped(3.0)

func go_to_player():
	dest = Player.location.position
	zoom_dest = Vector2(1, 1)