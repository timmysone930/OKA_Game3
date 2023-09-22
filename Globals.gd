extends Node

var game_level = 1
var game_score = 0
var is_pass = true
var is_allow_sound = true
var mole_hidden_count = 0

var game_obj = {
	0: {
		"game_board": "res://assets/images/game3_board_end_fail.png",
		"background": "res://assets/images/updated/game3_bg1.png",
		"character": "res://assets/images/game3_student_lose.png",
		"next_button": "res://assets/buttons/public_redo_yellow.png",
		"next_button_press": "res://assets/buttons/public_redo_green.png",
		"game_end_audio": "res://assets/sounds/hint_fail.mp3"
	},
	1: {
		"game_rule": "res://assets/images/updated/game3_count_lv1.png",
		"game_rule_vo": "res://assets/sounds/hint_mission1.mp3",
		"game_board": "res://assets/images/game3_board_end_lv1.png",
		"fail_game_board": "res://assets/images/updated/game3_board_end_fail.png",
		"background": "res://assets/images/updated/game3_bg1.png",
		"character": "res://assets/images/updated/game3_student_lv1.png",
		"price": "res://assets/images/updated/game3_block.png",
		"price_label": "積木",
		"delay_time": 10,
		"shock_time": 1,
		"random_time": 0.5,
		"level_board": "res://assets/images/updated/game3_lv1.png",
		"playback_speed": 1.25,
		"pass_score": 5,
		"next_button": "res://assets/buttons/public_nextlv_yellow.png",
		"next_button_press": "res://assets/buttons/public_nextlv_green.png",
		"game_time": 60,
		"holes_number": 3,
		"game_end_audio": "res://assets/sounds/hint_end_1.2.mp3"
	},
	2: {
		"game_rule": "res://assets/images/updated/game3_count_lv2.png",
		"game_rule_vo": "res://assets/sounds/hint_mission2.mp3",
		"game_board": "res://assets/images/game3_board_end_lv2.png",
		"fail_game_board": "res://assets/images/updated/game3_board_end_fail_lv2.png",
		"background": "res://assets/images/updated/game3_bg2.png",
		"character": "res://assets/images/updated/game3_student_lv2.png",
		"price": "res://assets/images/updated/game3_car.png",
		"price_label": "玩具車",
		"delay_time": 8,
		"shock_time": 1,
		"random_time": 0.5,
		"level_board": "res://assets/images/updated/game3_lv2.png",
		"playback_speed": 1.25,
		"pass_score": 8,
		"next_button": "res://assets/buttons/public_nextlv_yellow.png",
		"next_button_press": "res://assets/buttons/public_nextlv_green.png",
		"game_time": 90,
		"holes_number": 5,
		"game_end_audio": "res://assets/sounds/hint_end_2.2.mp3"
	},
	3: {
		"game_rule": "res://assets/images/updated/game3_count_lv3.png",
		"game_rule_vo": "res://assets/sounds/hint_mission3.mp3",
		"game_board": "res://assets/images/game3_board_end_lv3.png",
		"fail_game_board": "res://assets/images/updated/game3_board_end_fail_lv3.png",
		"background": "res://assets/images/updated/game3_bg3.png",
		"character": "res://assets/images/updated/game3_student_lv3.png",
		"price": "res://assets/images/updated/game3_robot.png",
		"price_label": "機器人",
		"delay_time": 5,
		"shock_time": 1,
		"random_time": 0.5,
		"level_board": "res://assets/images/updated/game3_lv3.png",
		"playback_speed": 1.25,
		"pass_score": 12,
		"next_button": "res://assets/buttons/public_again_yellow.png",
		"next_button_press": "res://assets/buttons/public_again_green.png",
		"game_time": 120,
		"holes_number": 5,
		"game_end_audio": "res://assets/sounds/hint_end_3.2.mp3"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
