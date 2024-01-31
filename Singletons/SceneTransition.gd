extends CanvasLayer

var curr_target: String
var emitting_signal = ""
onready var anim = $AnimationPlayer


func change_scene(target: String) -> void:
	curr_target = target
	Global.previous_menu = get_tree().current_scene.filename
	anim.play("MODULATE_TO_OPAQUE")
	
func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if (anim_name == "MODULATE_TO_OPAQUE"):
		if curr_target == "":
			if (emitting_signal == ""):
				pass
			else:
				SignalManager.emit_signal(emitting_signal)
		else:
			var _err = get_tree().change_scene(curr_target)
			anim.play("MODULATE_TO_TRANSPARENT")
	elif (anim_name == "MODULATE_TO_TRANSPARENT"):
		if curr_target == "":
			SignalManager.emit_signal("fade_finished",true)
		else:
			pass

func fade_to_transparent(target: String, signal_emitting: String):
	curr_target = target
	emitting_signal = signal_emitting
	anim.play("MODULATE_TO_TRANSPARENT")

func fade_to_opaque(target: String, signal_emitting: String):
	curr_target = target
	emitting_signal = signal_emitting
	anim.play("MODULATE_TO_OPAQUE")
