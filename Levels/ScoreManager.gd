extends Control

signal win

var scoreCount = 100
var score = 0
var playerWon = false

func _ready():
	gm.sm = self
	gm.connect("start", self, "start_game")
	update_text()

func start_game():
	$IntroText.visible = false
	$IntroText2.visible = false

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
		yield(get_tree().create_timer(3.0), "timeout")
		$WinText.visible = true
		$WinText2.visible = true
		$ScoreText.visible = false


func _on_Player_player_die():
	$LoseText.visible = true
