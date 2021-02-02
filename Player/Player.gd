extends "res://ModularPattern/Driver.gd"

class_name Player

enum PlayerState { CRUISE, ATTACK, DEAD }

signal kill_enemy
signal player_die

export var attackColor : Color 
export var attackSpeedLimit = 200.0
export var staminaUse = 75.0
export var staminaRegen = 50.0

var state = PlayerState.CRUISE
var originalColor
var stamina = 100.0

# ui vars
var staminaBarOffset : Vector2

# state vars
var oldState
var changeTimer = 0.0
var changeRate = 0.25
var oldSprite
var newSprite
var cruiseSize = Vector2(0.8, 0.8)
var attackSize = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()	
	gm.set_pc(self)
	originalColor = $KinematicBody2D/Sprite.modulate
	staminaBarOffset = $StaminaDisplay.rect_global_position
	set_state(PlayerState.CRUISE, true)

func _process(delta):
	._process(delta)
	update_state(delta)

func update_state(delta):
	var speed = $P_Movement.velocity.length()
	
	# stamina update
#	if Input.is_action_pressed("thrust"):
#		stamina = max(0.0, stamina - staminaUse * delta)
#	elif !Input.is_action_pressed("thrust"):
#		stamina = min(100.0, stamina + staminaRegen * delta)
#	$StaminaDisplay.value = stamina
#	$StaminaDisplay.rect_global_position = $KinematicBody2D.global_position + staminaBarOffset
#	$P_Movement.canAccelerate = true if stamina > 0.0 else false	
	
	if speed >= attackSpeedLimit:
		set_state(PlayerState.ATTACK)
	else:
		set_state(PlayerState.CRUISE)

	update_state_change(delta)
	
	match state:
		PlayerState.CRUISE:
			$CruiseDisplay.value = speed / attackSpeedLimit
			$CruiseDisplay.rect_global_position = $KinematicBody2D.global_position + staminaBarOffset
		PlayerState.ATTACK:
			$AttackDisplay.value = (speed - attackSpeedLimit) / attackSpeedLimit
			$AttackDisplay.rect_global_position = $KinematicBody2D.global_position + staminaBarOffset

func update_state_change(delta):
	changeTimer += delta	
	var changeAmt = changeTimer / changeRate
	if changeAmt < 1:
		oldSprite.set_scale(Vector2.ONE * (1 - changeAmt))
		newSprite.set_scale(Vector2.ONE * changeAmt)
	else:
		oldSprite.set_scale(Vector2())
		newSprite.set_scale(Vector2.ONE)

func set_state(newState, force = false):
	if (oldState == newState or state == PlayerState.DEAD) and !force:
		return
	
	# exit state
	match state:
		PlayerState.CRUISE:
			oldSprite = $KinematicBody2D/Sprite
		PlayerState.ATTACK:
			oldSprite = $KinematicBody2D/AttackSprite
	
	#enter state
	state = newState
	match state:
		PlayerState.CRUISE:
			newSprite = $KinematicBody2D/Sprite		
			newSprite.modulate = originalColor
			$CruiseDisplay.visible = true
			$AttackDisplay.visible = false
		PlayerState.ATTACK:
			newSprite = $KinematicBody2D/AttackSprite			
			newSprite.modulate = attackColor
			$AttackDisplay.visible = true			
			$CruiseDisplay.visible = false
		PlayerState.DEAD:
			$Particles_Death.global_position = $KinematicBody2D.global_position
			$Particles_Death.emitting = true
			$KinematicBody2D/CollisionShape2D.set_deferred("disabled", true)
			$KinematicBody2D.visible = false
			$StaminaDisplay.visible = false
			$CruiseDisplay.visible = false
			$AttackDisplay.visible = false
			
	changeTimer = newSprite.get_scale().x
	oldState = newState

func enemy_collision(enemy):
	if state == PlayerState.CRUISE:
		die()
	else:
		kill(enemy)

func kill(enemy):
	enemy.die()
	emit_signal("kill_enemy")

func die():
	set_state(PlayerState.DEAD)
	emit_signal("player_die")

