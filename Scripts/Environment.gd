extends Spatial

var rand = RandomNumberGenerator.new()
var building_seperation_size = 1
onready var roads = $Roads

func _ready():
	if LoadManager.buildings_prob.size() == 0:
		LoadManager.load_buildings()
	# -400, 1 is for road length of 200
	roads.translation.z = -Global.road_length * 2
	roads.scale.z = Global.road_length / 200
	$CarProgressDetector.translation.z = -Global.road_length / 10 - 50
	
	rand.randomize()
	generate_buildings(-6,270)
	generate_buildings(20,90)
		

func generate_buildings(trans_x,rotation_y):
	var current_length = 0
	var current_building_z = 0
	
	while current_length < Global.road_length:
		var building_type = LoadManager.buildings_prob[rand.randi_range(0,LoadManager.buildings_prob.size()-1)]
		var building_instance = building_type[rand.randi_range(0,building_type.size()-1)].instance()
		var building_mesh = building_instance.get_node(building_instance.name)
		var aabb = building_mesh.mesh.get_aabb()
		
		var building_length = (aabb.size[0]*5) # Size of the Building
		
		building_instance.scale = Vector3(5,5,5)
		building_instance.translation.x = trans_x
		building_instance.translation.z = current_building_z + -(building_length)/2
		building_instance.rotation.y = rotation_y / Global.model_sf
		
		current_length += building_length
		
		if (current_length < Global.road_length):
			$Buildings.add_child(building_instance)

		current_length += building_seperation_size
		current_building_z += -(building_seperation_size + building_length)
