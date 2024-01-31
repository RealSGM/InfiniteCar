extends Node

onready var moving_obj = $MovingObjects
onready var cam = $StationaryObjects/Camera
onready var tween = $Tween

export var cam_delay = 0.15

var player_scene = preload("res://Scenes/CharacterController.tscn")
var player
var roads = preload("res://Scenes/Environment.tscn")
var dist_travelled = Vector3.ZERO

var previous_road = null
var current_road = null

var scene_instance

func _ready():
	set_physics_process(false)
	
	
	if Global.moving_pos != null:
		# Load level details
		var scene = load("res://Scenes/TempScene.tscn")
		$MovingObjects.global_transform.origin = Global.moving_pos
		$StationaryObjects/Camera.far = Global.road_length
		if (scene != null):
			scene_instance = scene.instance()
			for child in scene_instance.get_children():
				var new_road = child.duplicate()
				new_road.get_node("CarProgressDetector").connect("body_entered",self,"update_roads")
				$MovingObjects.add_child(new_road)
		
		current_road = scene_instance.get_children()[0]
		if (scene_instance.get_children().size() == 2):
			previous_road = scene_instance.get_children()[1]
			
		
		add_player()
		# Apply camera fade out
		SignalManager.connect_signal("fade_finished",self,"_fade_finished")
		SceneTransition.fade_to_transparent("","fade_finished")
		yield(SceneTransition.get_node("AnimationPlayer"),'animation_finished')
	else:
		add_initial_road()
		add_player()
	
func _fade_finished(_isOpaque):
	# Tween Camera Position and Angle to new angle
	var curr_pos = cam.global_transform.origin
	var new_pos = Vector3(7,9,14)
	var curr_rot = cam.rotation
	var new_rot = Vector3(-15/Global.model_sf,0,0)
	var move_time = 1
	
	# Move Cam
	tween.interpolate_property(
							cam,
							"translation",
							curr_pos,
							new_pos,
							move_time * 2,
							Tween.TRANS_CUBIC,
							Tween.EASE_OUT)
	tween.start()
	
	# Rotate Cam
	tween.interpolate_property(
							cam,
							"rotation",
							curr_rot,
							new_rot,
							move_time,
							Tween.TRANS_QUAD,
							Tween.EASE_OUT)
	tween.start()
	
	set_physics_process(true)
	
func add_initial_road():
	# First time Road Setup
	var road_inst = roads.instance()
	road_inst.get_node("CarProgressDetector").connect("body_entered",self,"update_roads")
	current_road = road_inst
	moving_obj.add_child(road_inst,true)
	
func add_player():
	player = player_scene.instance()
	player.connect("move_camera",self,"move_camera")	
	# Add player chosen car model (WIP)
	$StationaryObjects.add_child(player,true)

func _physics_process(delta):
	var delta_distance = delta * Vector3.FORWARD * Global.speed
	dist_travelled += delta_distance
	moving_obj.global_transform.origin -= (delta_distance)

func move_camera(direction):
	yield(get_tree().create_timer(cam_delay),"timeout")
	var temp_pos = cam.global_transform.origin
	tween.interpolate_property(
							cam,
							"translation",
							temp_pos,
							temp_pos + (Vector3(3,0,0) * direction),
							Global.swipeTime - cam_delay,
							Tween.TRANS_LINEAR,
							Tween.EASE_OUT)
	tween.start()
	
func update_roads(body):
	if (body in get_tree().get_nodes_in_group("Player")):
		if (previous_road != null):
			previous_road.queue_free()
		print("Updating roads")
		previous_road = current_road
		var road_inst = roads.instance()
		current_road = road_inst
		
		var placement_dist = previous_road.translation.z - Global.road_length
		
		road_inst.translation = Vector3(0,0,placement_dist)
		road_inst.get_node("CarProgressDetector").connect("body_entered",self,"update_roads")
		moving_obj.add_child(road_inst,true)
	
func _on_CarRemoverDetector_body_entered(body):
	if body in get_tree().get_nodes_in_group("EnemyCar"):
		body.queue_free()



