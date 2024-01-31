extends Node

var car_scene = load("res://Scenes/EnemyCar.tscn")
	
func _calculate_car_amount(num) -> float:
	var num_cars = pow(exp(1),(-num+2)*Global.level)
	num_cars = floor(num_cars)
	return num_cars

func _on_SpawningTimer_timeout() -> void:
	randomize()
	var rand_num = rand_range(1,5)
	var _car_amount = _calculate_car_amount(rand_num)
	var positions = [1,4,7,10,13]
	positions.shuffle()
	for i in range(_car_amount):
		var car_instance = car_scene.instance()
		add_child(car_instance,true)
		
		car_instance.translation.z = -150
		car_instance.translation.x = positions[i]
