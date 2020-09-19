extends Spatial

# This Scene is meant for playing back sound groups. For simple, singular sound effects use stock Godot nodes, this is meant to play a random sound among a group with variations.

const SFX_dir = "res://Assets/SFX/" # all sound clips must reside somewhere in this directory

onready var player = $AudioStreamPlayer3D # playback backend

export(String, FILE, "*-01.wav") var SoundClip = "Assets/SFX/"
export(float) var MinimumDistance = 0.35 # gives optimal playback repetition for sound clip groups of different sizes. 

var min_distance = 0 # this  determines how ofte na sound is allowed to play (any Nth time) this is calculated automatically based on maximum_repetition
var clips = [] # holds loaded sound stream resources
var recently_played = [] # holds indexes of recently played 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var files = []
	var dir = Directory.new()
	dir.open(SFX_dir)
	dir.list_dir_begin()
	
	#print("SoundClip: ", SoundClip)
	var group = SoundClip.left(SoundClip.find_last('-')).right(SoundClip.find_last('/') + 1)
	print("group: ", group)
	
	while true:
		var file = dir.get_next()
		#print(file)
		if file == "":
			break
		elif not file.begins_with(".") and file.begins_with(group) and file.ends_with(".wav"):
			files.append(file)
		
	dir.list_dir_end()
	
	print(files)
	
	for f in files:
		clips.append(load(SFX_dir + f))
	
	min_distance = floor(len(clips) * MinimumDistance)
	
	#print ("Clips: ", len(clips))
	#print ("min_distance: ", min_distance)

func play():
	player.stream = clips[randi() % len(clips)]
	player.play()
	
	# TODO implement final randomization algorithm 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass