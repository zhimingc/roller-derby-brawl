extends Node2D

export (PackedScene) var debugEnemy
export (PackedScene) var basicEnemy

# spawn vars
export var spawnRate = 3.0
export var spawnRateMin = 1.0
export var spawnDist = 200.0
export var spawnRateUp = 0.1

var spawnTimer = 0.0
var debugUnits : Array
var debugNum = 100

func _ready():
	pass

func _process(delta):
	# update_debug()
	update_spawn(delta)

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
