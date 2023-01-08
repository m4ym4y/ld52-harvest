extends Node2D

export (PackedScene) var operation_scene
export (PackedScene) var dialogue_scene
export (PackedScene) var menu_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

static func menu_spec():
	return { "type": "menu" }

static func organ_spec(type, x, y):
	return { "type": type, "position": Vector2(x, y) }

static func operation_spec(organs, goal_organs):
	return { "type": "operation", "organs": organs, "goal_organs": goal_organs }

static func dialogue_spec(lines):
	return { "type": "dialogue", "lines": lines }

enum L { BOSS, PROTAG, BG, BLACK }

static func line_spec(text, type):
	var line = { "text": text, "boss": false, "bg": true, "protag": false }
	if type == L.BOSS:
		line.boss = true
	elif type == L.PROTAG:
		line.protag = true
	elif type == L.BLACK:
		line.bg = false
	return line

var current_level = 0
var game_spec = [
	menu_spec(),
	dialogue_spec([
		line_spec("Hello, Regular-sized Tony... I have a job for you.", L.BOSS),
		line_spec("Who are you? Did the boss send you?", L.PROTAG),
		line_spec("That's right, Regular-sized Tony. It's harvest time. And she says you're just the man for the job.", L.BOSS),
		line_spec("What do you want me to do?", L.PROTAG),
		line_spec("For this first body, you just need to get the heart out. Boss says she needs a new heart. And don't bang it up or anything.", L.BOSS),
		line_spec("You got it.", L.PROTAG),
		line_spec("Use your scalpel (left-click) to cut up the body. Once the required organ is completely uncovered, you can extract it (right-click).", L.BLACK),
		line_spec("Extract all the organs you need, and the level is complete. But be careful; every cut damages the body, and if you cut too much the entire body is ruined.", L.BLACK)
	]),
	operation_spec([
		organ_spec("heart", 544, 196),
		organ_spec("liver", 526, 338)
	], [
		"heart"
	]),
	dialogue_spec([
		line_spec("Good job, Regular-sized Tony... The boss is going to be very happy indeed, with her second heart.", L.BOSS),
		line_spec("I gotta ask... are you wearing a propeller beanie?", L.PROTAG),
		line_spec("...........................................................No.", L.BOSS),
		line_spec("You better focus up on what's important. This next body, you gotta extract the liver, see? Boss had a nasty night of drinking and she needs it today, capische?", L.BOSS),
		line_spec("Just leave it to me. They don't call me Regular-sized \"The Liver Extractor\" Tony for nothin'.", L.PROTAG)
	])
]

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()

func _on_level_complete(level):
	level.queue_free()
	current_level += 1
	next_level()

func _on_level_failure(level):
	level.queue_free()
	next_level()

func next_level():
	# TODO: have an ending scene instead
	if current_level >= game_spec.size():
		current_level = 0

	var level = game_spec[current_level]
	var scene
	
	if level.type == "menu":
		scene = menu_scene.instance()

	if level.type == "operation":
		scene = operation_scene.instance()
		scene.init(level.organs, level.goal_organs)
		scene.connect("failure", self, "_on_level_failure", [ scene ])

	if level.type == "dialogue":
		scene = dialogue_scene.instance()
		scene.init(level.lines)

	scene.connect("complete", self, "_on_level_complete", [ scene ])
	add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
