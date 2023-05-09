extends Node2D

# random gen for the world
# each time the player dies they will be transported into an new level
# or if they win they will be given a score and then be given an option too
# go into a new level, check bottom of page for more details

# ops
var ops_easy = {
	"max_health": 10, # the max number of health packs to spawn
	"max_spike":  4, # max number of spike platforms to spawn
	"max_walk":   2  # max number of walking enmie platforms to spawn
}
var ops_med = {
	"max_health": 4, # the max number of health packs to spawn
	"max_spike":  5, # max number of spike platforms to spawn
	"max_walk":   4  # max number of walking enmie platforms to spawn
}
var ops_hrd = {
	"max_health": 2,  # the max number of health packs to spawn
	"max_spike":  15, # max number of spike platforms to spawn
	"max_walk":   10  # max number of walking enmie platforms to spawn
}

var ops = {}

var ops_chk = {
	"max_health": 0, # the max number of health packs to spawn
	"max_spike":  0, # max number of spike platforms to spawn
	"max_walk":   0  # max number of walking enmie platforms to spawn
}
var le = 0
# if the platforms reach the max a "simple" platform will spawn
# these are platforms with nothing on them
var content = ""
# platform defines
var move_en = load("res://platform/move_en.tscn")
var health = load("res://platform/safe_health.tscn")
var simple = load("res://platform/simple.tscn")
var spikes = load("res://platform/spikes.tscn")
var spike_health = load("res://platform/spike_health.tscn")
var win = load("res://platform/win.tscn")

var rng = RandomNumberGenerator.new()

func set_ops():
	var file = File.new()
	file.open("res://save_data/score.txt", File.READ)
	content = file.get_as_text()
	file.close()
	
	if content == "0":
		ops = ops_easy
		le = 10
	elif content == "1":
		ops = ops_med
		le = 20
	elif content == "2":
		ops = ops_hrd
		le = 30
	else:
		ops = ops_hrd
		le = 100000000000

func _ready():
	set_ops()
	# get the difficulty
	# random number i picked out of my ass
	var start_x = 290
	var start_y = 370
	
	var last_y = start_y
	
	for i in range(0, 100):
		# each platform will be 10 away from the last
		start_x += 500
		
		# once platforms x postion is found we will decide if it's going to be slitgylt off
		# adds more veriiety to the platforms
		var random_x = create_whole(rng.randf_range(0, 100))
		start_x += random_x
		
		# randomly select a y hight as well
		# the reason we use last_y is so the platforms don't go off start_y
		# this means there still within the players reach
		# this has exposed a new feture in the game, the player can wall climb!
		# it's not a bug!
		var random_y = rng.randf_range(last_y-200, last_y+50)
		last_y = random_y
		
		# here we will decide what platform to pick, 0-4
		# 0) move_en
		# 1) health
		# 2) simple
		# 3) spike
		# 4) spikes_health
		# and see if it fits with the simple config
		var platform_num = create_whole(rng.randf_range(0, 5))
		#	"max_health": 0, # the max number of health packs to spawn
		#   "max_spike":  0, # max number of spike platforms to spawn
		#   "max_walk":  
		# walk
		
		if platform_num == 0 && ops_chk["max_walk"] != ops["max_walk"]:
			ops_chk["max_walk"] += 1
			
			var platform = move_en.instance()
			self.add_child(platform)
			platform.position += Vector2(start_x, last_y)
		# health
		elif platform_num == 1 && ops_chk["max_health"] != ops["max_health"]:
			ops_chk["max_health"] += 1
		
			var platform = health.instance()
			self.add_child(platform)
			platform.position += Vector2(start_x, last_y)
		# simple
		elif platform_num == 2:
			var platform = simple.instance()
			self.add_child(platform)
			platform.position += Vector2(start_x, last_y)
		# spike
		elif platform_num == 3 && ops_chk["max_spike"] != ops["max_spike"]:
			ops_chk["max_spike"] += 1
			
			var platform = spikes.instance()
			self.add_child(platform)
			platform.position += Vector2(start_x, last_y)
		# spike_health
		elif platform_num == 4 && ops_chk["max_health"] != ops["max_health"] && ops_chk["max_spike"] != ops["max_spike"]:
			ops_chk["max_spike"] += 1
			ops_chk["max_health"] += 1
			
			var platform = spikes.instance()
			self.add_child(platform)
			platform.position += Vector2(start_x, last_y)
		# if the max has reached
		else:
			if content == "1" or "2":
				var platform = spikes.instance()
				self.add_child(platform)
				platform.position += Vector2(start_x, last_y)
			else:
				var platform = simple.instance()
				self.add_child(platform)
				platform.position += Vector2(start_x, last_y)
	# add the win platform 
	var platform = win.instance()
	self.add_child(platform)
	platform.position += Vector2(start_x, last_y)
	



func create_whole(number):
	var x = str(number)
	x = x.split(".")[0]
	return int(x)















# 1) define the lenght of the map
# 2) start genrating from the player spawn platform
# 3) each platform genreated will go into a "collum" (predefined areas the platforms can spawn)
# with a hight offset too them
# 4) when a platform is genreated shack it against the config rules
# 5) if it goes over there max then DO NOT spawn it and spawn a "simple" platform instead
################################
#
#                         
#                         SPF
# PL      SPM
# SP SPS             SPW
#              SPS 
#
#################################
# KEY:
# PL  -> player
# SP  -> spawn platform
# SPS -> simple platform spikes
# SPM -> simple platform medcits
# SPW -> simple platform walk
# SPF -> simple platform finish


