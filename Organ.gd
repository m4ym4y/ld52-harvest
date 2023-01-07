extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var falling = false
const FALL_SPEED = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falling:
		rotation += delta * 5
		position.y += delta * 500

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func in_hitbox(target):
	if falling:
		return false
	return Geometry.is_point_in_polygon((target - position) * (1.0 / scale.x), get_node(animation).polygon)

func fall_out():
	light_mask = 1
	falling = true
