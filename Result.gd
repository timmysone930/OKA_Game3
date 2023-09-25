extends Node2D

signal Next_level
signal Reset_Level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_stage():		
	if Globals.is_pass:
		$ResultVideoPlayer.show()
		$ResultVideoPlayer.stream = load(Globals.game_obj[Globals.game_level].result_video)
		$ResultVideoPlayer.play()
	else:
		switchResult()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_NextButton_pressed():
	if Globals.game_level < 3 :
		Globals.game_level += 1
	elif Globals.game_level == 3 or Globals.game_level == 0:
		Globals.game_level = 1
	emit_signal("Next_level")


func _on_HomeButton_pressed():
	Globals.game_level = 1
	emit_signal("Reset_Level")

func switchResult():
	$ResultVideoPlayer.hide()
	if Globals.is_pass:
		$ResultBoard.texture = load(Globals.game_obj[Globals.game_level].game_board)
		$Character.texture = load(Globals.game_obj[Globals.game_level].character)
		$ButtonContainer/NextButton.texture_normal = load(Globals.game_obj[Globals.game_level].next_button)
		$ButtonContainer/NextButton.texture_pressed = load(Globals.game_obj[Globals.game_level].next_button_press)
		$FailContainer.hide()
		$TextContainer.show()
		$TextContainer/ScoreLabel.text = str(Globals.game_score)
		$TextContainer/PriceLabel.text = Globals.game_obj[Globals.game_level].price_label
		$TextContainer/PriceIcon.texture = load(Globals.game_obj[Globals.game_level].price)
		$ResultAudio.stream = load(Globals.game_obj[Globals.game_level].game_end_audio)
	else:
		$ResultBoard.texture = load(Globals.game_obj[Globals.game_level].fail_game_board)
		$Character.texture = load(Globals.game_obj[0].character)
		$ButtonContainer/NextButton.texture_normal = load(Globals.game_obj[0].next_button)
		$ButtonContainer/NextButton.texture_pressed = load(Globals.game_obj[0].next_button_press)
		$ResultAudio.stream = load(Globals.game_obj[0].game_end_audio)
		$TextContainer.hide()
		$FailContainer.show()
		Globals.game_level = 0
		Globals.is_pass = true
		$FailContainer/ScoreLabel.text = str(Globals.game_score)
	$ResultAudio.play()

func _on_ResultVideoPlayer_finished():
	switchResult()
