extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var vinny = get_node("Camera2D/Vignette")
	vinny.modulate = Color(randf()*0.8 + 0.1, randf()*0.8 + 0.1, randf()*0.8 + 0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
