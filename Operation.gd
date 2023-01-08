extends Node2D

export (PackedScene) var organ_scene
export (PackedScene) var organ_goal_scene

signal complete
signal failure

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tool_offset = Vector2(-35, 35)
var did_cut = false
var done = false
var failed = false

var last_mouse_pos = Vector2(0,0)
var distance_since_cut = 99

var goal_organs = []
var goal_organ_x = 930
var goal_organ_y = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	if not goal_organs.size():
		init([
			{ "type": "heart", "position": Vector2(544, 196) },
			{ "type": "liver", "position": Vector2(526, 338) }
		], [
			"heart",
			"liver"
		])
	pass # Replace with function body.

func init(organ_positions, goals, health: int = 100):
	# clean up example organs
	for n in $Organs.get_children():
		$Organs.remove_child(n)
		n.queue_free()

	print('initializing heath', health)
	$Health.value = health
	
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
		yield(get_tree().create_timer(0.5), "timeout")
		$CompleteDialog.visible = true
		done = true

func fail_stage():
	done = true
	failed = true
	yield(get_tree().create_timer(0.5), "timeout")
	$FailureDialog.visible = true

var last_cut_time = 0

func _input(event):
	if event is InputEventMouseMotion and not done:
		if event.button_mask & 1:
			var target = event.position + tool_offset
			if Geometry.is_point_in_polygon(target, $TorsoBounds.polygon):
				distance_since_cut += (target - last_mouse_pos).length()
				last_mouse_pos = target
				if distance_since_cut > 10:
					distance_since_cut = 0
					var time = Time.get_ticks_msec()
					var time_since_cut = time - last_cut_time
					last_cut_time	= time
					$Health.value -= 0.25 if time_since_cut > 50 else 1
					if $Health.value <= 0:
						fail_stage()
					$BodyMask.emit_signal('cut', target)
					get_node("Tool/CPUParticles2D").emitting = true
		elif event.button_mask == 0:
			get_node("Tool/CPUParticles2D").emitting = false
	elif event is InputEventMouseButton:
		if event.button_mask & 1 and done:
			if not failed:
				emit_signal("complete")
			else:
				emit_signal("failure")
		if event.button_mask & 2 and not done:
			var extracted = false
			var target = event.position + tool_offset
			$Tool.animation = "spoon"
			for organ in $Organs.get_children():
				if organ.in_hitbox(target):
					var uncovered = $BodyMask.is_uncovered(organ)
					print('organ: ', organ.animation, ' uncovered: ', uncovered)
					if uncovered:
						extracted = true
						complete_organ(organ)
			if not extracted:
				get_node("Tool/CPUParticles2D").emitting = true
				$ScoopPlayer.play()
				$Health.value -= 5

		if event.button_mask & 1 and not done:
			$Tool.animation = 'scalpel_active'
			$CutPlayer.playing = true
		if event.button_mask & 1 == 0:
			if $Tool.animation != "spoon":
				$Tool.animation = 'scalpel'
				$CutPlayer.playing = false
