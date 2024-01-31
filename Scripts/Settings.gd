extends Node


func _ready():
	pass


func _on_MasterVolumeSlider_value_changed(value):
	Global.current_volume = value


func _on_BackButton_pressed():
	SceneTransition.change_scene(Global.previous_menu)
