extends Control

signal win

var scoreCount = 100
var score = 0
var playerWon = false

func _ready():
	update_text()

func add_score():
	score += 1
	update_text()
	check_win()
	
func update_text():
	$ScoreText.bbcode_text = "[center]" + String(max(0, scoreCount - score))

func _on_Player_kill_enemy():
	add_score()

func check_win():
	if score >= scoreCount and !playerWon:
		emit_signal("win")
		playerWon = true
