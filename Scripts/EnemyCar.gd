extends RigidBody

onready var tween = $Tween
onready var left_light_timer = $Timers/LightTimerL
onready var right_light_timer = $Timers/LightTimerR
onready var left_indicator = $LeftIndicator
onready var right_indicator = $RightIndicator
onready var delay = $Timers/Delay

var breaking = false
var flash_boolean = 0
var available_cars = ["police","race","raceFuture","sedan","sedanSports","suv","suvLuxury","taxi","truck","truckFlat","van"]
var speed = Vector3.ZERO

func _ready():
	randomize()
	var random_car = rand_range(0,available_cars.size())
	var _file_name = available_cars[random_car] + ".dae"
	var car_scene = load("res://Assets/KenneyCars/police.dae")
	var car_instance = car_scene.instance()
	add_child(car_instance,true)
	rotate(Vector3.UP,PI)
	var chance_for_indicator = randi() % 3
	var random_time = rand_range(25,30)
	speed = _calc_speed()
	if chance_for_indicator == 2:
		delay.wait_time = random_time
		delay.start()

func _physics_process(_delta):
	if (breaking):
		#higher as postive is backwards
		linear_velocity = Vector3(0,0,10 + Global.level)
	else:
		linear_velocity = speed

func _calc_speed():
	var lane = Global.calc_curr_lane(translation.x)
	var laneSpeed = Vector3(0,0,5 + lane*2 + (Global.level))
	print(lane)
	return laneSpeed
	
func _calc_move_to_next_lane():
	var curr_lane = Global.calc_curr_lane(translation.x)
	
	match curr_lane:
		1:
			move_to_next_lane(Vector3.RIGHT,right_light_timer)
		5:
			move_to_next_lane(Vector3.LEFT,left_light_timer)
		_:
			var left_or_right = randi() % 2
			if left_or_right == 1:
				if ($LeftIndicatorCheck.get_overlapping_bodies().size() == 0):
					move_to_next_lane(Vector3.LEFT,left_light_timer)
				else:
					delay.start()
					print("cancelled")
			else:
				if ($RightIndicatorCheck.get_overlapping_bodies().size() == 0):
					move_to_next_lane(Vector3.RIGHT,right_light_timer)
				else:
					delay.start()
					print("cancelled")
	speed = _calc_speed()

func move_to_next_lane(direction,timer):
	timer.start()
	tween.interpolate_property(
							self,
							"translation",
							global_transform.origin,
							global_transform.origin + (Vector3(3,0,0) * direction),
							4,
							Tween.TRANS_SINE,
							Tween.EASE_IN_OUT)
	tween.start()

func _left_indicator():
	flash_boolean = 1 - flash_boolean
	left_indicator.light_energy = 50 * flash_boolean

func _right_indicator():
	flash_boolean = 1 - flash_boolean
	right_indicator.light_energy = 50 * flash_boolean
	
func _end_flashing(_a,_b):
	left_indicator.light_energy = 0
	right_indicator.light_energy = 0
	right_light_timer.stop()
	left_light_timer.stop()

func _on_FrontCheck_area_entered(area):
	breaking = true

func _on_FrontCheck_area_exited(area):
	if($FrontCheck.get_overlapping_areas().size() == 0):
		breaking = false
