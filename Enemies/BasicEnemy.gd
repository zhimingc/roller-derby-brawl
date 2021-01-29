extends RigidBody2D

export var moveForce = 100.0
export var forceUp = 10.0
export var moveRate = 3.0
export var rateUp = 0.1

var pcBody
var moveTimer = 0.0
var addedMove = 0.0
var rateMin = 0.5
var forceMax = 250.0

func _ready():
	pcBody = gm.pc.body
	moveTimer = moveRate
	addedMove = moveForce
	
func _process(delta):
	update_movement(delta);
	
func update_movement(delta):
	moveTimer += delta
	
	if moveTimer >= moveRate:
		var moveDir = (pcBody.global_position - global_position).normalized()
		set_linear_velocity(moveDir * addedMove)
		addedMove = min(addedMove + forceUp, forceMax)
		moveRate = max(moveRate - rateUp, rateMin)
		moveTimer = 0.0

func _on_BasicEnemy_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().enemy_collision(self)

func die():
	$Particles_Death.global_position = global_position
	$Particles_Death.emitting = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
