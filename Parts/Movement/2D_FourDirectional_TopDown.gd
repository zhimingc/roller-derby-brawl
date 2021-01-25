extends "res://ModularPattern/Part.gd"

export var ACCELERATION = 5000
export var DRAG = .9
export var MAX_SPEED = 2500

var velocity = Vector2()

func _physics_update(delta, body):
	var axis = get_move_input()
	if axis.length() <= 0.0:
		# $AnimationPlayer.play("PC_idle")
		pass
	else:
		apply_acceleration(axis * ACCELERATION * delta)
		#$AnimationPlayer.play("PC_walk")
	
	apply_drag()
	body.move_and_slide(velocity)

func get_move_input():
	var axis = Vector2()
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func apply_acceleration(acceleration):
	velocity += acceleration
	if velocity.length() >= MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

func apply_drag():
	velocity *= DRAG
