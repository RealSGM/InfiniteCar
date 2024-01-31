extends Spatial

# Nodepaths
onready var moving_obj = $MovingObjects
const player_scene = preload("res://Scenes/CharacterController.tscn")
const roads = preload("res://Scenes/Environment.tscn")

# Constants (Fixed during gameplay)
const road_starting_position = 20

var previous_road = null
var current_road = null

var player = null
var dist_travelled = Vector3.ZERO

func _ready():
	LoadManager.load_buildings()
	set_physics_process(false)
	add_player()
	add_initial_road()
	set_physics_process(true)

func add_initial_road():
	# First time Road Setup
	var road_inst = roads.instance()
	road_inst.translation = Vector3(0,0,road_starting_position)
	road_inst.get_node("CarProgressDetector").connect("body_entered",self,"update_roads")
	current_road = road_inst
	moving_obj.add_child(road_inst,true)

func add_player():
	player = player_scene.instance()
	player.connect("move_camera",self,"move_camera")	
	player.script = null
	# Add player chosen car model (WIP)
	$StationaryObjects.add_child(player,true)

func _physics_process(delta):
	# Move moving objects forward
	var delta_distance = delta * Vector3.FORWARD * Global.speed
	dist_travelled += delta_distance
	moving_obj.global_transform.origin -= (delta_distance)


func update_roads(body):
	if (body in get_tree().get_nodes_in_group("Player")):
		if (previous_road != null):
			previous_road.queue_free()
			
		previous_road = current_road
		var road_inst = roads.instance()
		current_road = road_inst
		
		var placement_dist = previous_road.translation.z - Global.road_length
		
		road_inst.translation = Vector3(0,0,placement_dist)
		road_inst.get_node("CarProgressDetector").connect("body_entered",self,"update_roads")
		moving_obj.add_child(road_inst,true)
	
