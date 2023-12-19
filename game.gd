extends Node2D

var score = 0
var last_hole
var correct_point = 1
var wrong_point = 0
var picked_correct_count = 0
var picked_wrong_count = 0

var wrong_answer_path = "res://assets/answers/wrong/"
var correct_answer_path = Globals.game_obj[Globals.game_level].correct_path
var last_answer_index
var mole_container
signal is_ended

class ImageAnswerEntry:
	var image_path: String
	var is_correct: bool

var image_answers = [] #TODO: REMOVE
var is_mole_peeping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	if Globals.game_level == 1:
		$MolesContainer.visible = false
		$MolesContainer_lv1.visible = true
		mole_container = $MolesContainer_lv1
	else:
		$MolesContainer.visible = true
		$MolesContainer_lv1.visible = false
		mole_container = $MolesContainer
	
	for i in range(mole_container.get_child_count()):
		var mole = mole_container.get_child(i)
		mole.connect('Whacked_Correct', self, "add_score")
		mole.connect('Whacked_Wrong', self, "deduct_score")
		mole.connect('Next_Batch', self, "mole_action")
	
	$GameCountDown.connect("timeout", self, "end_game")
	$GameCountDown.wait_time = Globals.game_obj[Globals.game_level].game_time
	$GameCountDown.start()
	
	$ScoreContainer/GameLevel.texture = load(Globals.game_obj[Globals.game_level].level_board)
	$Background.texture = load(Globals.game_obj[Globals.game_level].background)
	
	mole_action()
	$ScoreContainer/ScoreAnimationPlayer.play("Slide_down")

func mole_action():
	if Globals.mole_hidden_count == Globals.game_obj[Globals.game_level].holes_number:
		is_mole_peeping = false
		Globals.mole_hidden_count = 0
		
	if is_mole_peeping:
		return
	
	var answer_arr = random_pick_answer()
	for i in range(mole_container.get_child_count()):
		var mole = mole_container.get_child(i)
		if mole.prev_animation in ['Hide', 'Whack_Success', 'Whack_Wrong', '']:
			var answer = answer_arr[i]
			mole.peep(answer)
			
	is_mole_peeping = true

func add_score():
	Globals.game_score += correct_point
	$ScoreContainer/Score/ScoreLabel.text = str(Globals.game_score)
	$AnswerAnimation/Box.texture = load("res://assets/images/updated/green_box.png")
	$AnswerAnimation/Label.text = "答對了！"
	$AnswerAnimation/AnimationPlayer.play("PopUp")

func deduct_score():
	if Globals.game_score > 0 :
		Globals.game_score -= wrong_point
	else :
		Globals.game_score = 0
	$ScoreContainer/Score/ScoreLabel.text = str(Globals.game_score)
	$AnswerAnimation/Box.texture = load("res://assets/images/updated/red_box.png")
	$AnswerAnimation/Label.text = "還需努力！"
	$AnswerAnimation/AnimationPlayer.play("PopUp")

func end_game():
	$Timer.stop()
	for i in range(mole_container.get_child_count()):
		var mole = mole_container.get_child(i)
		mole.end_game()
	if Globals.game_score < Globals.game_obj[Globals.game_level].pass_score:
		Globals.is_pass = false
		#Globals.game_level = 0
	emit_signal("is_ended")
	

func get_image_files_in_folders(folder_path, is_correct):
	var arr = []
	
	var dir = Directory.new()
	dir.open(folder_path)
	if dir.open(folder_path) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var filepath = folder_path + file
			if file.get_extension().to_lower() == "import":
				filepath = filepath.replace(".import", "")
				var entry = ImageAnswerEntry.new()
				entry.image_path = filepath
				entry.is_correct = is_correct
				arr.append(entry)
			file = dir.get_next()
		dir.list_dir_end()
	
	return arr

func random_weight_selector():
	var correct_weight = 0.55
	var wrong_weight = 0.45
	var total_weight = correct_weight + wrong_weight
	var random_value = rand_range(0, total_weight)
	if random_value <= correct_weight:
		return 0
	else:
		return 1	

func random_pick_answer():
	var correct_arr = get_image_files_in_folders(correct_answer_path, true)
	var wrong_arr = get_image_files_in_folders(wrong_answer_path, false)
	
	var arr = []
	
	# Shuffle and slice arrays
	correct_arr.shuffle()  
	wrong_arr.shuffle()
	
	# pop out the selected items
	var correct_ans = correct_arr.pop_front()
	arr.append(correct_ans)
	
	var wrong_ans = wrong_arr.pop_front()
	arr.append(wrong_ans)

	var remain_hole_length = Globals.game_obj[Globals.game_level].holes_number - arr.size()
	for i in range (remain_hole_length):
		var select_weight = random_weight_selector()
		if select_weight == 0 and !correct_arr.empty():
			var ans = correct_arr.pop_front()
			arr.append(ans)
		elif select_weight == 1 and !wrong_arr.empty():
			var ans = wrong_arr.pop_front()
			arr.append(ans)
	arr.shuffle()
	return arr
	#if picked_correct_count < 1:
	#	arr = correct_arr
	#	picked_correct_count += 1
	#elif picked_wrong_count < 1:
	#	arr = wrong_arr
	#	picked_wrong_count += 1
	#else:
	#	if picked_correct_count + picked_wrong_count < Globals.game_obj[Globals.game_level].holes_number:
	#		var select_weight = random_weight_selector()
	#		if select_weight == 0:
	#			arr = correct_arr
	#			picked_correct_count += 1
	#		else:
	#			arr = wrong_arr
	#			picked_wrong_count += 1

	#	if picked_correct_count + picked_wrong_count == Globals.game_obj[Globals.game_level].holes_number:
	#		picked_correct_count = 0
	#		picked_wrong_count = 0
	#var random_index = randi() % arr.size()
	#var currentEntry = arr[random_index]
	#return currentEntry

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var seconds = int($GameCountDown.time_left)
	$ScoreContainer/CountDown/TimeLabel.text = str(seconds) + " 秒"
