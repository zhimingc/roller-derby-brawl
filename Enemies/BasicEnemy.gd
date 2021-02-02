extends RigidBody2D

export var circleSprite : Texture
export var bloodCol : Color
export var moveForce = 150.0
export var forceUp = 10.0
export var moveRate = 3.0
export var rateUp = 0.25
export var startColor : Color
export var endColor : Color

var pcBody
var moveTimer = 0.0
var addedMove = 0.0
var rateMin = 0.25
var rateMax
var forceMax = 250.0
var dead = false

func _ready():
	if gm.pc == null:
		return
	pcBody = gm.pc.body
	moveTimer = moveRate
	addedMove = moveForce
	rateMax = moveRate
	
func connect_manager(manager):
	manager.connect("killAll", self, "delayed_die")
	
func _process(delta):	
	if pcBody == null:
		return
	update_movement(delta);

func update_movement(delta):
	moveTimer += delta
	
	if moveTimer >= moveRate:
		var moveDir = (pcBody.global_position - global_position).normalized()
		set_linear_velocity(moveDir * addedMove)
		addedMove = min(addedMove + forceUp, forceMax)
		moveRate = max(moveRate - rateUp, rateMin)
		$Sprite.modulate = startColor.linear_interpolate(endColor, 1.0 - (moveRate / rateMax))
		moveTimer = 0.0

func _on_BasicEnemy_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().enemy_collision(self)

func die():
	$Particles_Death.global_position = global_position
	$Particles_Death.emitting = true
	$Particles_Death.modulate = $Sprite.modulate
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	gm.cam.trigger_shake_cam(0.25)
	gm.emit_signal("play_sfx_pitch", "squish", rand_range(0.8, 1.1), -12)
	dead = true
	spawn_death_decal()
	yield(get_tree().create_timer(3.0), "timeout")	
	queue_free()
	
func delayed_die():
	if dead:
		return
	dead = true
	yield(get_tree().create_timer(rand_range(0.0, 1.5)), "timeout")
	die()

func spawn_death_decal():
	var num = rand_range(3, 5)
	for i in num:
		var newCircle = Sprite.new()
		get_parent().call_deferred("add_child", newCircle)
		newCircle.texture = circleSprite
		var posSpread = 20
		var col = 0.05
		var sat = 0.3
		newCircle.global_position = global_position + Vector2(rand_range(-posSpread, posSpread), rand_range(-posSpread, posSpread))
		newCircle.global_scale = Vector2.ONE * rand_range(0.1, 0.5)
		#newCircle.modulate = bloodCol + Color(rand_range(-colSpread, colSpread), rand_range(-colSpread, colSpread), rand_range(-colSpread, colSpread), 0)
		newCircle.modulate = Color.from_hsv($Sprite.modulate.h + rand_range(-col, col), $Sprite.modulate.s + rand_range(-sat * 2, -sat), $Sprite.modulate.v, 0.8)
		newCircle.z_index = -10
