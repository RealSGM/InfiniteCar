extends Control

func _ready():
	SignalManager.connect_signal("fade_finished",get_tree().get_root().get_node("/root/SplashScreen"),"_on_fade_finished")
	SceneTransition.fade_to_transparent("","")
	
func _on_fade_finished(_isOpaque):
	SceneTransition.change_scene("res://Scenes/MainMenu.tscn")
