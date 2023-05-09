extends KinematicBody2D


var speed = 200 # player speed
var jump_speed = -200 # plaer jump hight
var gravity = 400 # player gravity
var flor = false # floor collison check
var dubble = false
var health = 100 # the health of the player in %, when it gets to 0 or below the player dies

# player movment storage
var velocity = Vector2.ZERO

# player sprites (left and right move)
onready var left = $Player_L
onready var right = $PlayerR

var lives = 3
var score = 0
var score_last = global_position.x

################################################
# WIN && LOSS
################################################
func win_load():
	save()
	get_tree().change_scene("res://titles/level_win_title.tscn")
	# save the data
	
func death_load():
	if lives != 0:
		var tomb = load("res://en/tomb.tscn")
		var platform = tomb.instance()
		get_tree().get_root().add_child(platform)
		platform.position += global_position
		
		lives -= 1
		$Camera2D/player_lives/RichTextLabel.text = str(lives)
		# teleport player to start
		global_position = Vector2(284, 300)
		velocity = Vector2.ZERO
		health = 100
		score = 0
		$Camera2D/RichTextLabel.text = "Score: "+str(score)
		
	else:
		# save the data
		save()
		get_tree().change_scene("res://titles/death.tscn")

func save():
	var file = File.new()
	file.open("res://save_data/score.txt", File.WRITE)
	file.store_string((str(score)))
	file.close()

################################################
# INPUT
################################################
# check for besic left and right movement
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		# show right hide left
		left.hide()
		right.show()
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		left.show()
		right.hide()
		velocity.x -= speed


################################################
# EVERY FRAME
################################################
func _physics_process(delta):
	update_health()
	# get the player input
	get_input()
	
	# apply gravity too it
	velocity.y += gravity * delta
	
	# move the player 
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# add the jump too it
	if Input.is_action_just_pressed("space"):
		if flor:
			velocity.y = jump_speed
		if !flor and !dubble:
			velocity.y = jump_speed
			dubble = true


################################################
# SURRUDING CHECKS
################################################
# check for things that have entered the detection earea of the "floor" node
func _on_floor_body_entered(body):
	# convert the body into a string (makes it easiier to handle
	# check if it's the floor
	body = str(body).split(":")[0]
	print(body)
	
	if "floor" in body:
		dubble = false
		flor = true
	elif body == "health_pickup":
		plus_health()
	
	# enmie dammage
	elif "spike" in body:
		min_health()
	elif "enemy" in body:
		min_health()
	
	# floor fallen
	# play death animation
	elif "death" in body:
		death_load()
	# win
	elif "win" in body:
		win_load()
	

# check for things that have exited the detection earea of the "floor" node
func _on_floor_body_exited(body):
	# convert the body into a string (makes it easiier to handle
	body = str(body).split(":")[0]

	# check if it's the floor
	if "floor" in body:
		flor = false



################################################
# HEALTH
################################################
		
		
func update_health():
	# will run every fram to accuratly update the players health
	# update the "health_lbl" to the current health percentage
	$Camera2D/player_lives/RichTextLabel.text = str(lives)
	
func plus_health():
	lives += 1

func min_health():
	death_load()

#############################################
# SCORE
#############################################
func create_int_pos(num):
	# example num we need to convert: -1234.003910931
	var new_num = str(num).split(".")[0]
	# num will now be "-1234"
	# need to get rid of the "-"
	new_num = new_num.split("-")[1]
	
	var new = int(new_num) / 10
	
	new_num = str(new).split(".")[0]
	
	return int(new_num)

func _on_score_track_timeout():
	var score_now = global_position.x
	if score_last < score_now:
		score_now = score_last - score_now
		score_now = create_int_pos(score_now)
		score += score_now
	
		$Camera2D/RichTextLabel.text = "Score: "+str(score)
	else:
		print("went back wards!")
