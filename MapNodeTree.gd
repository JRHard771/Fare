extends Node2D

var MapNode = preload("res://MapNode.tscn")
var MapPath = preload("res://MapPath.tscn")
var terrain = {
	dungeon = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/castle-ruins.png"),
		color = Color(0.5, 0.5, 0.5)
		},
	city = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/castle.png"),
		color = Color(1.0, 1.0, 1.0)
		},
	cave = {
		pad = pow(120, 2),
		image = preload("res://sprites/map/cave-entrance.png"),
		color = Color(0.5, 0.5, 0.5)
		},
	village = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/huts-village.png"),
		color = Color(0.75, 0.5, 0.0)
		},
	mountain = {
		pad = pow(240, 2),
		image = preload("res://sprites/map/peaks.png"),
		color = Color(1.0, 0.95, 0.9)
		},
	forest = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/pine-tree.png"),
		color = Color(0.3, 0.7, 0.5)
		},
	marker = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/position-marker.png"),
		color = Color(1.0, 1.0, 1.0)
		},
	road = {
		pad = pow(160, 2),
		image = preload("res://sprites/map/stone-path.png"),
		color = Color(1.0, 0.8, 0.6)
		},
	ocean = {
		pad = pow(240, 2),
		image = preload("res://sprites/map/big-wave.png"),
		color = Color(0.6, 0.8, 1.0)
		},
	river = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/river.png"),
		color = Color(0.6, 0.8, 1.0)
		},
	door = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/exit-door.png"),
		color = Color(0.75, 0.5, 0.0)
		},
	room = {
		pad = pow(80, 2),
		image = preload("res://sprites/map/stone-sphere.png"),
		color = Color(0.5, 0.5, 0.5)
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
		new_node.set_terrain(type, terrain[type])
		new_node.add_to_group('MapNodes')
		new_node.add_to_group(type)
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
				new_node.set_terrain(type, terrain[type])
				new_node.add_to_group('MapNodes')
				new_node.add_to_group(type)
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

func generate_rivers():
	for n in get_tree().get_nodes_in_group('mountain'):
		var node = null
		for o in n.exits:
			if o.type == 'forest' and randi()%5 == 0:
				node = o
				break
		if node:
			var run = true
			while run:
				node.set_terrain('river', terrain['river'])
				node.remove_from_group('forest')
				node.add_to_group('river')
				run = false
				for x in node.exits:
					if x.type == 'forest':
						run = true
						node = x
						break
		if n.exits.size() == 1:
			n.set_terrain('ocean', terrain['ocean'])
			n.remove_from_group('mountain')
			n.add_to_group('ocean')

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var root = MapNode.instance()
	root.position = Vector2(0, 0)
	root.set_terrain('city', terrain['city'])
	root.add_to_group('MapNodes')
	root.add_to_group('city')
	add_child(root)
	Player.location = root
	populate(root)
	for i in range(5):
		var nodes = get_tree().get_nodes_in_group('Open Nodes')
		for n in nodes:
			populate(n)
	loop_map_nodes()
	generate_rivers()
