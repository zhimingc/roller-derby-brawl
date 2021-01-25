extends "res://ModularPattern/Part.gd"

export var ACCELERATION = 500
export var DRAG = .98
export var MAX_SPEED = 500

var velocity = Vector2()

func _physics_update(delta, body : KinematicBody2D):
	var axis = get_move_input()
	if axis > 0.0:
		apply_acceleration(axis * ACCELERATION * delta * body.transform.x)
		#$AnimationPlayer.play("PC_walk")
	
	apply_drag()
	body.move_and_slide(velocity)

func get_move_input():
	var axis = 0
	axis = int(Input.is_action_pressed("thrust"))
	return axis

func apply_acceleration(acceleration):
	velocity += acceleration
	if velocity.length() >= MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

func apply_drag():
	velocity *= DRAG
