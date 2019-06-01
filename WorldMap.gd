extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var vinny = get_node("Vignette")
	vinny.modulate = Color(0.17, 0.5, 0.34)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
