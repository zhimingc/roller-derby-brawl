extends Control

var score = 0

func _ready():
	update_text()

func add_score():
	score += 1
	update_text()
	
func update_text():
	$ScoreText.bbcode_text = "[center]" + String(score)

func _on_Player_kill_enemy():
	add_score()
