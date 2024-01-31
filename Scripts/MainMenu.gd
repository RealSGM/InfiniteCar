extends Node

onready var settings_menu = preload("res://Scenes/Settings.tscn")
onready var game = preload("res://Scenes/Game.tscn")

func _ready():
	PositionManager.center_item($FullBG/MainBG,$FullBG/MainBG/MainVBox,20,20)
	PositionManager.center_item($FullBG,$FullBG/MainBG,0,0)
	PositionManager.center_item($FullBG/TitleBG,$FullBG/TitleBG/TitleLabel,40,10)
	PositionManager.center_item($FullBG,$FullBG/TitleBG,0,0,0,20,true,false)

func _fade_finished():
	# Saving Moving Objects to PackedScene for transfer
	Global.previous_menu = get_tree().current_scene.filename

	var moving_objs = get_node("GameDemo/MovingObjects").duplicate()
	Global.moving_pos = moving_objs.translation

	for child in moving_objs.get_children():
		child.set_owner(moving_objs)

	var scene = PackedScene.new()
	scene.pack(moving_objs)
	var _err2 = ResourceSaver.save("res://Scenes/TempScene.tscn",scene)
	
	var _err3 = get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Play_pressed():
	var game_demo = $GameDemo
	var tween = $Tween
	var moving_obj = $GameDemo/MovingObjects
	var title = $FullBG/TitleBG
	var main = $FullBG/MainBG
	var anim = $AnimationPlayer
	
	if title != null:
		title.hide()
	if main != null:	
		main.hide()
		
	anim.play("BGFadeOut")
	
	# Smoothly halt vehicle
	game_demo.set_physics_process(false)
	tween.interpolate_property(
							moving_obj,
							"translation",
							moving_obj.global_transform.origin,
							moving_obj.global_transform.origin + (Vector3(0,0,10)),
							1,
							Tween.TRANS_SINE,
							Tween.EASE_OUT)
	tween.start()
	yield(tween,"tween_completed")
	
	SignalManager.connect_signal("fade_finished",self,"_fade_finished")
	SceneTransition.fade_to_opaque("","fade_finished")

func _on_Store_pressed():
	SceneTransition.change_scene("res://Scenes/Store.tscn")

func _on_Settings_pressed():
	SceneTransition.change_scene("res://Scenes/Settings.tscn")

func _on_Quit_pressed():
	get_tree().quit()
