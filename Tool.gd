extends AnimatedSprite

const FOLLOW_SPEED = 3000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Tool_animation_finished():
	if animation == "spoon":
		animation = "scalpel"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_mouse_position()
