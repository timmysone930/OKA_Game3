extends Node2D

var prev_animation = ""
var is_whacked = false
var wrong_whack_texture = "res://assets/images/updated/game3_gopher_wrong.png"
var right_whack_texture = "res://assets/images/updated/game3_gopher_right_new.png"

var is_correct
var is_game_ended = false
var sink_timer = null
var whack_timer = null

signal Whacked_Correct
signal Whacked_Wrong
signal Next_Batch

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func peep(answer):
	var texture = load(answer.image_path)
	is_correct = answer.is_correct
	$Answer.texture = texture
	$AnimationPlayer.playback_speed = Globals.game_obj[Globals.game_level].playback_speed
	$AnimationPlayer.play("Peep")
	
func sink():
	#hide the mole after the delay_time
	if sink_timer != null:
		sink_timer.stop()
		sink_timer.disconnect("timeout", self, "on_sink_timeout")
		sink_timer.queue_free()
		
	sink_timer = Timer.new()
	sink_timer.wait_time = Globals.game_obj[Globals.game_level].delay_time
	sink_timer.connect("timeout", self, "on_sink_timeout")
	get_tree().get_root().add_child(sink_timer)
	sink_timer.start()
		
func on_sink_timeout():
	if !is_whacked && prev_animation != "Whack_Wrong" && prev_animation != "Whack_Success":
		$AnimationPlayer.play("Hide")
	elif is_whacked && is_correct:
		$CorrectAnswer.visible = false
		$AnimationPlayer.play("Whack_Success")
	elif is_whacked && !is_correct:
		$WrongAnswer.visible = false
		$AnimationPlayer.play("Whack_Wrong")	
	
	sink_timer.stop()
	sink_timer.disconnect("timeout", self, "on_sink_timeout")
	sink_timer.queue_free()
	sink_timer = null

func whack(is_correct):
	is_whacked = true
	if is_correct:
		emit_signal("Whacked_Correct")
		if Globals.is_allow_sound:
			$CorrectAudio.play()
		get_node("Mole").set_texture(load(right_whack_texture))
		get_node("Mole").position.y = 40
		get_node("Mole").region_rect = Rect2(0, 0, 347, 680)
		$CorrectAnswer.visible = true
	else:
		emit_signal("Whacked_Wrong")
		if Globals.is_allow_sound:
			$WrongAudio.play()
		get_node("Mole").set_texture(load(wrong_whack_texture))
		get_node("Mole").position.y = 160
		$WrongAnswer.visible = true

func end_game():
	$AnimationPlayer.stop(true)
	$Mole.visible = false
	$Answer.visible = false
	$CorrectAnswer.visible = false

func is_idle():
	return !$AnimationPlayer.is_playing()

func on_animation_finished(anim_name):
	prev_animation = anim_name
	if anim_name == "Peep":
		sink()
	elif anim_name in ["Whack_Success", "Whack_Wrong", "Hide"] :
		is_whacked = false
		Globals.mole_hidden_count += 1
		emit_signal("Next_Batch")
	
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && prev_animation != "Whack":
		$Mole/Area2D/CollisionShape2D.disabled = true
		
		#Clear animation status
		$AnimationPlayer.clear_caches()
		$AnimationPlayer.clear_queue()
		$AnimationPlayer.stop(true)
		
		whack(is_correct)
		
		
