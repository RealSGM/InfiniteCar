extends RigidBody

onready var timer = $MoveTimer
onready var tween = $Tween

export var new_pos = Vector2.ZERO
export var old_pos = Vector2.ZERO
export var decceleration = 1

var isScreenTouch = false
var canSwipe = true
var currentLane = 3

signal move_camera(direction)

func _ready() -> void:
	# When summoning in the player car, reset their wheel x rotation to 0
	timer.wait_time = Global.swipeTime
	currentLane = Global.calc_curr_lane(translation.x)

func _input(event):
	if (isScreenTouch && canSwipe):
		old_pos = new_pos
		new_pos = event.position
		# Calculate direction of swipe
		var angle = rad2deg(old_pos.angle_to(new_pos))
		if (angle > 0) && (currentLane > 1):
			move_vehicle(Vector3.LEFT)
		elif (angle < 0) && (currentLane < 5):
			move_vehicle(Vector3.RIGHT)
		
	if !(event is InputEventScreenTouch):
		return
	elif !isScreenTouch:
		start_touch_detection()
	else:
		end_touch_detection()
	
func start_touch_detection() -> void:
	isScreenTouch = true
	
func end_touch_detection() -> void:
	isScreenTouch = false
	new_pos = Vector2.ZERO
	apply_central_impulse(Vector3(-linear_velocity.x,0,0) * decceleration)	
	
func move_vehicle(direction) -> void:
	
	# Consider chance for L/R Indication
	var temp_pos = global_transform.origin
	var wheelRotation = Vector3(0,45/Global.model_sf,0)
	var wheels = {0:"wheel_frontLeft",1:"wheel_frontRight"}
	
	timer.start()
	canSwipe = false
	currentLane += direction.x
	
	tween.interpolate_property(
							self,
							"translation",
							temp_pos,
							temp_pos + (Vector3(3,0,0) * direction),
							Global.swipeTime,
							Tween.TRANS_LINEAR,
							Tween.EASE_IN_OUT)
	tween.start()
	
	emit_signal("move_camera",direction)
		
	#Initial turning of the wheels
	for i in wheels.keys():
		tween.interpolate_property(
							get_node("Car/" + wheels[i]),
							"rotation",
							Vector3.ZERO,
							wheelRotation * -direction.x,
							(Global.swipeTime * 0.75),
							Tween.TRANS_ELASTIC,
							Tween.EASE_OUT)
		tween.start()
	yield(get_tree().create_timer(Global.swipeTime * 0.75),"timeout")
	
	#Resetting of the wheels
	for i in wheels.keys():
		tween.interpolate_property(
							get_node("Car/" + wheels[i]),
							"rotation",
							get_node("Car/" + wheels[i]).rotation,
							Vector3.ZERO,
							(Global.swipeTime * 0.25),
							Tween.TRANS_LINEAR,
							Tween.EASE_IN_OUT)
		tween.start()
	yield(get_tree().create_timer(Global.swipeTime * 0.25),"timeout")
	
func _on_MoveTimer_timeout() -> void:
	canSwipe = true
