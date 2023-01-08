extends Node2D

export (PackedScene) var operation_scene
export (PackedScene) var dialogue_scene
export (PackedScene) var menu_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

static func menu_spec():
	return { "type": "menu" }

static func o(type, x, y):
	return { "type": type, "position": Vector2(x, y) }

static func operation_spec(organs, goal_organs, health: int = 100):
	return { "type": "operation", "organs": organs, "goal_organs": goal_organs, "health": health }

static func dialogue_spec(lines, distance: float = 1.0):
	return { "type": "dialogue", "lines": lines, "distance": distance }

enum L { BOSS, PROTAG, BG, BLACK }

static func l(text, type):
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
		l("Hello, Regular-sized Tony... I have a job for you.", L.BOSS),
		l("Who are you? Did the boss send you?", L.PROTAG),
		l("That's right, Regular-sized Tony. It's harvest time. And she said that I should find you.", L.BOSS),
		l("What do you want me to do?", L.PROTAG),
		l("For this first body, you just need to get the heart out. Boss says she needs a new heart. don't bang it up or anything.", L.BOSS),
		l("You got it.", L.PROTAG),
		l("Use your scalpel (left-click) to cut up the body. Once the required organ is completely uncovered, you can extract it (right-click).", L.BLACK),
		l("Extract all the organs you need, and the level is complete. But be careful; every cut damages the body, and if you cut too much the entire body is ruined.", L.BLACK)
	], 1.0),

	operation_spec([
		o("heart", 544, 196),
		o("liver", 526, 338)
	], [
		"heart"
	]),

	dialogue_spec([
		l("Good job, Regular-sized Tony... The boss is going to be very happy indeed, with her second heart.", L.BOSS),
		l("I gotta ask... are you wearing a propeller beanie?", L.PROTAG),
		l("...........................................................No.", L.BOSS),
		l("...You should focus up on what's important. This next body, you gotta extract the liver, see? Boss had a nasty night of drinking and she needs it today, capische?", L.BOSS),
		l("Just leave it to me. They don't call me Regular-sized \"The Liver Extractor\" Tony for nothin'.", L.PROTAG)
	], 0.95),

	operation_spec([
		o("heart", 544, 196),
		o("liver", 526, 338)
	], [
		"liver"
	]),

	dialogue_spec([
		l("How come that guy looked exactly like the one before him?", L.PROTAG),
		l("The boss is a busy lady... You think she has time to find a bunch of different looking guys?", L.BOSS),
		l("I guess that makes sense. So, what's my next job?", L.PROTAG),
		l("So glad that you asked. Our next body used to be known as Iron-Bladder Stevie. The Boss had him whacked, and now she's auctioning his bladder to the highest bidder.", L.BOSS),
		l("You gotta scoop it out from his abdomen. Along with his right kidney. Unfortunately, his body is pretty banged up. So extra careful, please.", L.BOSS),
		l("Say no more.", L.PROTAG)
	], 0.9),

	operation_spec([
		o("heart", 544, 196),
		o("liver", 526, 338),
		o("kidney", 401, 386),
		o("bladder", 468, 466)
	], [
		"bladder",
		"kidney"
	], 75),

	dialogue_spec([
		l("You truly are an artist, Regular-sized Tony. Watching you work... it's entrancing.", L.BOSS),
		l("I'm just doing my job. I enjoy, it. It's almost like some kind of game.", L.PROTAG),
		l("Your work tonight isn't even close to finished. This next body... he's another ex-gangster.", L.BOSS),
		l("I'm glad the work isn't over. Tell me what I need to pull out this time.", L.PROTAG),
		l("This goon was a real powerhouse. His body just has one freakishly huge mitochondria. And we need it for research.", L.BOSS),
		l("Where is it?", L.PROTAG),
		l("Can't say. You'll just have to find it. Are you up to the task?", L.BOSS),
		l("No need to ask. You can count on me.", L.PROTAG)
	], 0.75),

	operation_spec([
		o("heart", 544, 196),
		o("liver", 526, 338),
		o("kidney", 401, 386),
		o("bladder", 468, 466),
		o("mitochondria", 411, 161)
	], [
		"mitochondria"
	], 67),

	dialogue_spec([
		l("I was wondering something.", L.BOSS),
		l("Is it lonely, extracting organs every day?", L.BOSS),
		l("Why are you asking me that?", L.PROTAG),
		l("Do you have anyone here with you?", L.BOSS),
		l("..............................", L.PROTAG),
		l("There was someone for a while. But he died in a freak organ harvesting accident.", L.PROTAG),
		l("He was lying on the operating table for a nap... and... I accidentally harvested his organs.", L.PROTAG),
		l("I'm so sorry. I shouldn't have brought it up.", L.BOSS),
		l("It's ok. Despite the grief, his heart will always live on inside of me.", L.PROTAG),
		l("Will it make you feel better if I give you another job?", L.BOSS),
		l("You know just how to cheer me up.", L.PROTAG),
		l("I try. This one is a real straightforward job. We need a spleen, a liver, and a gallbladder.", L.BOSS),
		l("Of course.", L.PROTAG)
	], 0.5),

	operation_spec([
		o("heart", 544, 196),
		o("liver", 526, 338),
		o("kidney", 401, 386),
		o("bladder", 468, 466),
		o("spleen", 469, 237),
		o("gallbladder", 549, 387)
	], [
		"spleen",
		"liver",
		"gallbladder"
	], 100),

	dialogue_spec([
		l("You haven't stepped out of the shadows the whole time you've been here.", L.PROTAG),
		l("I hope that you don't find it rude of me.", L.BOSS),
		l("Just strange.", L.PROTAG),
		l("Many people find me very strange. I don't like to draw attention to myself.", L.BOSS),
		l("Strange can be good. People think that I'm strange too.", L.PROTAG),
		l("You're quite a character, Regular-sized Tony. I think...", L.BOSS),
		l("I think I'm beginning to understand why the boss told me that I have to find you.", L.BOSS),
		l("My organ-harvesting shop has been feeling less empty tonight. I really do enjoy having you here.", L.PROTAG),
		l(".................................", L.BLACK),
		l(".................................", L.BLACK)
	], 0.4)
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
		scene.init(level.organs, level.goal_organs, level.health)
		scene.connect("failure", self, "_on_level_failure", [ scene ])

	if level.type == "dialogue":
		scene = dialogue_scene.instance()
		scene.init(level.lines, level.distance)

	scene.connect("complete", self, "_on_level_complete", [ scene ])
	add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
