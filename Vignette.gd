extends Sprite

var color_dest = modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("player_moved", self, "get_color_dest")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate = modulate.linear_interpolate(color_dest, delta * 2)

func get_color_dest():
	color_dest = Player.location.get_node("Sprite").self_modulate
