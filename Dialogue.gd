extends Node2D

signal complete

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lines
var current_line = 0
var complete = false
var elapsed = 0
var done_typing = false
export var time_per_char = 0.05

export var text_starting_pitch = 0.75
export var text_pitch_range = 0.5

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	if not lines:
		init([
			{ "text": "Hello, Regular-Sized Tony. I have a job for you...",
				"boss": true,
				"protag": false,
				"bg": true
			},
			{ "text": "Oh yeah? Tell me more.",
				"boss": false,
				"protag": true,
				"bg": true
			},
			{ "text": "s SALDSJ fslkdf jlksfjlkDSJKLF LJSDLFJ",
				"boss": false,
				"protag": true,
				"bg": true
			},
			{ "text": "SKF JSDKLF JLSDFJLK SD",
				"boss": true,
				"protag": false,
				"bg": true
			},
		])

func init(_lines):
	lines = _lines
	render_current_line()

func render_current_line():
	if current_line >= lines.size():
		if not complete:
			emit_signal("complete")
		complete = true
		return

	var line = lines[current_line]
	elapsed = 0
	done_typing = false

	$Continue.visible = false
	$Label.text = ""
	$BossPortrait.light_mask = 1 if line.boss else 4
	$ProtagonistPortrait.light_mask = 1 if line.protag else 4
	$DialogueBackground.visible = line.bg

func _input(event):
	if event is InputEventMouseButton and not complete:
		if event.button_mask & 1:
			if done_typing:
				current_line += 1
				render_current_line()
			else:
				$Label.text = lines[current_line].text

var last_text = ""

func _process(delta):
	if complete:
		return

	elapsed += delta
	var text = lines[current_line].text

	if text != $Label.text:
		$Label.text = text.substr(0, min(floor(elapsed / time_per_char),text.length()))
		if $Label.text != last_text:
			$TypeSound.pitch_scale = text_starting_pitch + rng.randf() * text_pitch_range
			$TypeSound.play()
		last_text = $Label.text
	else:
		$Continue.visible = true
		done_typing = true
