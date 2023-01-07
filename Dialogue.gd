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
var time_per_char = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
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
		}
	])
	pass # Replace with function body.

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

	$Label.text = ""
	$BossPortrait.visible = line.boss
	$ProtagonistPortrait.visible = line.protag
	$DialogueBackground.visible = line.bg

func _unhandled_input(event):
	if event is InputEventMouseButton and not complete:
		if event.button_mask & 1 and done_typing:
			current_line += 1
			render_current_line()

func _process(delta):
	if complete:
		return

	elapsed += delta
	var text = lines[current_line].text

	if text != $Label.text:
		print("setting text")
		$Label.text = text.substr(0, min(floor(elapsed / time_per_char),text.length()))
	else:
		done_typing = true
