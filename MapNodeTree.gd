extends Node2D

var MapNode = preload("res://MapNode.tscn")
var MapPath = preload("res://MapPath.tscn")
var terrain = {
	dungeon = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/castle-ruins.png")
		},
	city = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/castle.png")
		},
	cave = {
		pad = pow(120, 2),
		image = preload("res://sprites/map/cave-entrance.png")
		},
	door = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/exit-door.png")
		},
	village = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/huts-village.png")
		},
	mountain = {
		pad = pow(240, 2),
		image = preload("res://sprites/map/peaks.png")
		},
	forest = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/pine-tree.png")
		},
	marker = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/position-marker.png")
		},
	road = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/stone-path.png")
		},
	room = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/stone-sphere.png")
		}
	}

func random_terrain():
	var d20 = randi() % 20
	if d20 == 0:
		return 'village'
	elif d20 == 1:
		return 'dungeon'
	elif d20 == 2:
		return 'cave'
	elif d20 <= 7:
		return 'road'
	elif d20 <= 13:
		return 'mountain'
	return 'forest'

func add_path(node_a, node_b):
	var path = MapPath.instance()
	path.node_from = node_a
	path.node_to = node_b
	node_a.add_exit(node_b)
	add_child(path)

func path_length(type_a, type_b):
	return sqrt(max(terrain[type_a]['pad'], terrain[type_b]['pad']))

func populate(mnode):
	for i in range(2):
		spawn_node(mnode, random_terrain())
		mnode.remove_from_group('Open Nodes')

func check_spawn(pos, type):
	var others = get_tree().get_nodes_in_group('MapNodes')
	for n in others:
		if pos.distance_squared_to(n.position) < max(terrain[type]['pad'], terrain[n.type]['pad']):
			return false
	return true

func spawn_node(parent, type):
	var edge = Vector2.RIGHT.rotated( randf() * PI ) * (path_length(parent.type, type) + 1)
	if check_spawn(parent.position + edge, type):
		var new_node = MapNode.instance()
		new_node.position = parent.position + edge
		new_node.type = type
		new_node.set_texture(terrain[type]['image'])
		new_node.set_label(type.capitalize())
		new_node.add_to_group('MapNodes')
		new_node.add_to_group('Open Nodes')
		add_child(new_node)
		add_path(parent, new_node)
		return true
	else:
		var rads = deg2rad(8)
		for i in range(44):
			edge = edge.rotated(rads)
			if check_spawn(parent.position + edge, type):
				var new_node = MapNode.instance()
				new_node.position = parent.position + edge
				new_node.type = type
				new_node.set_texture(terrain[type]['image'])
				new_node.set_label(type.capitalize())
				new_node.add_to_group('MapNodes')
				new_node.add_to_group('Open Nodes')
				add_child(new_node)
				add_path(parent, new_node)
				return true
	return false

func loop_map_nodes():
	var ray = RayCast2D.new()
	ray.collide_with_areas = true
	ray.collide_with_bodies = false
	ray.exclude_parent = true
	var offset = randi()%360
	for n in get_tree().get_nodes_in_group('MapNodes'):
		n.add_child(ray)
		for angle in range(16):
			var rads = deg2rad(angle * 22.5 + offset)
			ray.cast_to = Vector2(cos(rads), sin(rads)) * 240
			ray.force_raycast_update()
			var other = ray.get_collider()
			if !other or other.get_parent().get_filename() == MapPath.get_path():
				continue
			elif n.exits.find(other) == -1:
				add_path(n, other.get_parent())
				break
		n.remove_child(ray)
	ray.free()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var root = MapNode.instance()
	root.position = Vector2(0, 0)
	root.type = 'city'
	root.set_texture(terrain['city']['image'])
	root.set_label('City')
	root.add_to_group('MapNodes')
	add_child(root)
	Player.location = root
	populate(root)
	for i in range(5):
		var nodes = get_tree().get_nodes_in_group('Open Nodes')
		for n in nodes:
			populate(n)
	loop_map_nodes()
