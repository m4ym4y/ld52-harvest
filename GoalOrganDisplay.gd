extends Node2D

export (PackedScene) var organ_scene;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var height = 330

const MARGIN = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(organ_type):
	$Organ.animation = organ_type

func complete():
	$GoalCheck.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
