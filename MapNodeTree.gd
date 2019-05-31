extends Node2D

var IMG_RUINS = preload("res://sprites/map/castle-ruins.png")
var IMG_CASTLE = preload("res://sprites/map/castle.png")
var IMG_CAVE = preload("res://sprites/map/cave-entrance.png")
var IMG_DOOR = preload("res://sprites/map/exit-door.png")
var IMG_VILLAGE = preload("res://sprites/map/huts-village.png")
var IMG_MOUNTAIN = preload("res://sprites/map/peaks.png")
var IMG_FOREST = preload("res://sprites/map/pine-tree.png")
var IMG_MARKER = preload("res://sprites/map/position-marker.png")
var IMG_ROAD = preload("res://sprites/map/stone-path.png")
var IMG_FLOOR = preload("res://sprites/map/stone-sphere.png")
var images = [IMG_RUINS, IMG_CASTLE, IMG_CAVE, IMG_DOOR, IMG_VILLAGE,
			  IMG_MOUNTAIN, IMG_FOREST, IMG_MARKER, IMG_ROAD, IMG_FLOOR]
var MapNode = preload("res://MapNode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var new_node = MapNode.instance()
		new_node.set_texture(images[randi()%10])
		add_child(new_node)
