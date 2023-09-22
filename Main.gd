extends Node2D

var scene = preload("res://game.tscn")
var scene_instance = null
var isReset = false
onready var bgm_animation = $ButtonContainer/BGM/BGMButton/BGMAnimation
onready var start_button_animation = $TitleContainer/StartButton/StartButton/StartButtonAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.is_allow_sound:
		$TitleVO.play()
	start_button_animation.play("Flash")
	$GameSceneContainer/GameStartContainer/GameStartAnimation.connect("animation_finished", self, "on_animation_finished")
	$LeaveContainer/LeaveBoard/AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	$ResultContainer/Result.connect("Next_level", self, "start_next_level")
	$ResultContainer/Result.connect("Reset_Level", self, "reset_level")

func _on_StartButton_pressed():
	$TitleVO.stop()
	$ButtonContainer/ButtonAudio.play()
	$TitleContainer.hide()
	$ButtonContainer.show()
	$GameSceneContainer.show()
	$GameSceneContainer/GameStartContainer/GameStartAnimation.play("Start")
	isReset = false

#BGM Button
func _on_BGMButton_button_up():
	$ButtonContainer/ButtonAudio.play()
	bgm_animation.play("onClickOver")
	control_music()

func _on_BGMButton_button_down():
	bgm_animation.play("onClick")

func control_music():
	Globals.is_allow_sound = !Globals.is_allow_sound
	var is_playing = $BGMPlayer.is_playing()
	if Globals.is_allow_sound:
		$BGMPlayer.play()
		$ButtonContainer/BGM/BGMButton.texture_normal = load("res://assets/buttons/public_music.png")
		setSoundMute($GameSceneContainer/StartGameMusic, false)
		setSoundMute($GameSceneContainer/CountDownMusic, false)
		setSoundMute($GameSceneContainer/GameStartContainer/GameRuleVO, false)
		setSoundMute($ResultContainer/Result/ResultAudio, false)
		setSoundMute($ButtonContainer/ButtonAudio, false)
	else:
		$BGMPlayer.stop()
		$ButtonContainer/BGM/BGMButton.texture_normal = load("res://assets/buttons/public_music_off.png")
		setSoundMute($GameSceneContainer/StartGameMusic, true)
		setSoundMute($GameSceneContainer/CountDownMusic, true)
		setSoundMute($GameSceneContainer/GameStartContainer/GameRuleVO, true)
		setSoundMute($ResultContainer/Result/ResultAudio, true)
		setSoundMute($ButtonContainer/ButtonAudio, true)

func setSoundMute(path, shouldMute):
	if shouldMute:
		path.volume_db = -80
	else:
		path.volume_db = 0

#Exit Button
func _on_ExitButton_button_up():
	$ButtonContainer/Exit/ExitButton/ExitAnimation.play("onClickOver")
	$LeaveContainer.show()
	get_tree().paused = true
	$LeaveContainer/LeaveBoard/AnimationPlayer.play("Slide_down")

func _on_ExitButton_button_down():
	$ButtonContainer/ButtonAudio.play()
	$ButtonContainer/Exit/ExitButton/ExitAnimation.play("onClick")

func _on_HomeButton_pressed():
	$ButtonContainer/ButtonAudio.play()
	Globals.game_level = 1
	if scene_instance != null:
		scene_instance.queue_free()
		scene_instance = null
	$GameSceneContainer/GameStartContainer/GameStartAnimation.stop(true)
	reset_level()
	$LeaveContainer/LeaveBoard/AnimationPlayer.play("Slide_up")

func _on_ResumeButton_pressed():
	$ButtonContainer/ButtonAudio.play()
	$LeaveContainer/LeaveBoard/AnimationPlayer.play("Slide_up")

func on_animation_finished(anim_name):
	if anim_name == "Start":
		$GameSceneContainer/GameStartContainer.texture = load(Globals.game_obj[Globals.game_level].game_rule)
		$GameSceneContainer/GameStartContainer/GameRuleVO.stream = load(Globals.game_obj[Globals.game_level].game_rule_vo)
		$GameSceneContainer/GameStartContainer/GameRuleVO.play()
	elif anim_name == "Slide_up":
		$LeaveContainer.hide()
		get_tree().paused = false
		
func _on_GameRuleVO_finished():
	if !isReset:	
		$GameSceneContainer/GameStartContainer.hide()
		if scene_instance == null:
			scene_instance = scene.instance()
		else:
			scene_instance.queue_free()
		$GameSceneContainer/Game.add_child(scene_instance)
		scene_instance.connect("is_ended", self, "on_game_end")
		scene_instance.connect("is_ended", $ResultContainer/Result, "set_stage")
	

func on_game_end():
	if scene_instance != null:
		scene_instance.queue_free()
		scene_instance = null
	$ResultContainer.show()

func start_next_level():
	$ButtonContainer/ButtonAudio.play()
	$ResultContainer/Result/ResultAudio.stop()
	$ResultContainer.hide()
	$GameSceneContainer/GameStartContainer.show()
	$GameSceneContainer/GameStartContainer/GameStartAnimation.play("Start")
	Globals.game_score = 0
	$Background.texture = load(Globals.game_obj[Globals.game_level].background)

func reset_level():
	$ButtonContainer/ButtonAudio.play()
	isReset = true
	$GameSceneContainer/GameStartContainer/GameRuleVO.stop()
	$ResultContainer/Result/ResultAudio.stop()
	Globals.game_score = 0
	$Background.texture = load(Globals.game_obj[Globals.game_level].background)
	$ResultContainer.hide()
	$TitleContainer.show()
	$ButtonContainer.hide()
	$GameSceneContainer.hide()
	$GameSceneContainer/GameStartContainer.show()
	if Globals.is_allow_sound:
		$TitleVO.play()

