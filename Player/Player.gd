extends "res://ModularPattern/Driver.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	gm.set_pc(self)
	._ready()

func die():
	$Particles_Death.global_position = $KinematicBody2D.global_position
	$Particles_Death.emitting = true
	$KinematicBody2D/CollisionShape2D.set_deferred("disabled", true)
	$KinematicBody2D.visible = false
