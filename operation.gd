extends Node2D

export (PackedScene) var organ_scene
export (PackedScene) var organ_goal_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tool_offset = Vector2(-35, 35)
var did_cut = false

var goal_organs = []
var goal_organ_x = 930
var goal_organ_y = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	init([
		{ "type": "heart", "position": Vector2(544, 196) },
		{ "type": "liver", "position": Vector2(526, 338) }
	], [
		"heart",
		"liver"
	])
	pass # Replace with function body.

func init(organ_positions, goals):
	# clean up example organs
	for n in $Organs.get_children():
		$Organs.remove_child(n)
		n.queue_free()
	
	for o in organ_positions:
		var organ = organ_scene.instance()
		organ.light_mask = 3
		organ.animation = o.type
		organ.position = o.position
		$Organs.add_child(organ)
	
	for g in goals:
		goal_organs.push_back(g)
		var goal_organ = organ_goal_scene.instance()
		goal_organ.scale = Vector2(0.5, 0.5)
		goal_organ.init(g)
		goal_organ.set_name(g)
		goal_organ.set_position(Vector2(goal_organ_x, goal_organ_y))
		goal_organ_y -= goal_organ.height * goal_organ.scale.y
		$GoalOrgans.add_child(goal_organ)

func complete_organ(organ):
	organ.fall_out()
	goal_organs.erase(organ.animation)

	var goal = get_node("GoalOrgans/" + organ.animation)
	if goal:
		goal.complete()

	if goal_organs.size() == 0:
		print("stage complete!!")

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & 1:
			var target = event.position + tool_offset
			if Geometry.is_point_in_polygon(target, $TorsoBounds.polygon):
				$BodyMask.emit_signal('cut', target)
				get_node("Tool/CPUParticles2D").emitting = true
				$ProgressBar.value -= 0.0002 * event.speed.length()
		elif event.button_mask == 0:
			get_node("Tool/CPUParticles2D").emitting = false
	elif event is InputEventMouseButton:
		if event.button_mask & 2:
			var target = event.position + tool_offset
			for organ in $Organs.get_children():
				if organ.in_hitbox(target):
					var uncovered = $BodyMask.is_uncovered(organ)
					print('organ: ', organ.animation, ' uncovered: ', uncovered)
					if uncovered:
						complete_organ(organ)
