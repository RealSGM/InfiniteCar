extends Node

# UI
var current_volume = 0.5
var previous_menu = ""

# Gameplay
var laneCount = 5
var swipeTime = 0.5
var level = 1
var spawning_frequency = 1
var speed = 10
# Minimum 200
var road_length = 800

# Scene Change Data Transfer
var moving_pos = null

var model_sf = 57.2957777778
var buttonTimer:Timer


func _ready() -> void:
	buttonTimer = Timer.new()
	buttonTimer.set_wait_time(5)
	var _err = buttonTimer.connect("timeout", self, "on_button_timeout")
	add_child(buttonTimer,true)

func calc_curr_lane(xPos) -> int:
	return int(((xPos-1) / 3) + 1)

func calc_lane_pos(lane) -> int:
	return int(((lane - 1) * 3)+1)

func on_button_timeout() -> void:
	level += 1
