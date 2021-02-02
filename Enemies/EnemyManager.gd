extends Node2D

export (PackedScene) var debugEnemy
export (PackedScene) var basicEnemy

# spawn vars
export var spawnRate = 2.8
export var spawnRateMin = 0.5
export var spawnDist = 250.0
export var spawnRateUp = 0.2

var spawnTimer = 0.0
var debugUnits : Array
var debugNum = 100
var stop = true

signal killAll

func _ready():
	gm.connect("start", self, "start_game")
	spawnTimer = spawnRate

func start_game():
	stop = false

func _process(delta):
	if stop:
		return
	# update_debug()
	update_spawn(delta)

func _input(ev):
	#if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
	#	stop()
	pass
	
func ready_debug():
	for i in debugNum:
		var debug = debugEnemy.instance()
		add_child(debug)
		debug.global_position = get_spawn_location()
		debugUnits.append(debug)

func update_debug():
	for i in debugNum:
		var distToPc = debugUnits[i].global_position.distance_to(gm.pc.body.global_position)
		if distToPc < spawnDist:
			debugUnits[i].global_position = get_spawn_location()

func update_spawn(delta):
	spawnTimer += delta
	if spawnTimer >= spawnRate:
		spawn_enemy()
		spawnTimer = 0.0
		spawnRate = max(spawnRateMin, spawnRate - spawnRateUp)

func get_spawn_location():
	var i = 0
	var xLim = (Vector2(-100, 100) * $SpawnRange.global_scale.x) / 2.0
	var yLim = (Vector2(-100, 100) * $SpawnRange.global_scale.y) / 2.0
	var spawnLoc = Vector2(rand_range(xLim.x, xLim.y), rand_range(yLim.x, yLim.y))
	var curDist = spawnLoc.distance_to(gm.pc.body.global_position)
	
	while curDist < spawnDist and i < 100:
		i += 1
		spawnLoc = Vector2(rand_range(xLim.x, xLim.y), rand_range(yLim.x, yLim.y))
		curDist = spawnLoc.distance_to(gm.pc.body.global_position)

	return spawnLoc

func spawn_enemy():
	var newEnemy = basicEnemy.instance()
	var spawnLoc = get_spawn_location()
	add_child(newEnemy)
	newEnemy.global_position = spawnLoc
	newEnemy.connect_manager(self)

func stop():
	emit_signal("killAll")
	stop = true

func _on_ScoreManager_win():
	stop()
