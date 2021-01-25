extends Node

var parts
var children
var body

func _ready():
	parts = Array()
	children = get_children()
	for child in children:
		if child is Part:
			parts.append(child)
	body = find_first_in_children(KinematicBody2D)

func _physics_process(delta):
	if !body:
		return
	for part in parts:
		part._physics_update(delta, body)
		
func _process(delta):
	if !body:
		return
	for part in parts:
		part._update(delta, body)
	
func find_first_in_children(type):
	children = get_children()
	for child in children:
		if child is type:
			return child
	return null
