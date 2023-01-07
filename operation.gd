extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tool_offset = Vector2(-35, 35)
var did_cut = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & 1:
			var target = event.position + tool_offset
			if Geometry.is_point_in_polygon(target, $TorsoBounds.polygon):
				$BodyMask.emit_signal('cut', target)
				get_node("Tool/CPUParticles2D").emitting = true
		if event.button_mask == 0:
			get_node("Tool/CPUParticles2D").emitting = false
