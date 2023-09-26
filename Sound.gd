extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$SoundContainer/SoundBoard/AnimationPlayer.play("Slide_down")
	pass # Replace with function body.


func changeToNewScene():
	# Load the scene
	var newScene = "res://Main.tscn"
	# Change the scene
	get_tree().change_scene(newScene)

func _on_NoSoundButton_pressed():
	Globals.is_allow_sound = false
	changeToNewScene()


func _on_YesSoundButton_pressed():
	Globals.is_allow_sound = true
	changeToNewScene()
