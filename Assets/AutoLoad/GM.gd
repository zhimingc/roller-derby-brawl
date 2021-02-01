extends Node

var pc
var cam

signal play_sfx(sfx)
signal play_sfx_pitch(sfx, pitch)

func set_pc(player):
	pc = player
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
