extends "res://ModularPattern/Part.gd"

export var rotateSpeed = 90

func _update(delta, node):
	var mousePos = node.get_global_mouse_position()
	var vecToTarget = mousePos - node.global_position
	var angle = rad2deg(node.transform.x.angle_to(vecToTarget.normalized()))
	
	var rotate = rotateSpeed * delta
	if abs(angle) < rotate:
		node.look_at(node.get_global_mouse_position())
	else:
		node.rotate(deg2rad(rotate * sign(angle)))
