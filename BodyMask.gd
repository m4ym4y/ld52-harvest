extends Light2D

signal cut(position)

var brush
var brush_mask
var image
var viewport

const CUT_SIZE = 20

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func refresh_texture():
  var tex = ImageTexture.new()
  tex.create_from_image(image)
  texture = tex

# Called when the node enters the scene tree for the first time.
func _ready():
  viewport = Vector2(
  ProjectSettings.get_setting("display/window/size/width"),
  ProjectSettings.get_setting("display/window/size/height"))

  image = Image.new()
  image.create(viewport.x, viewport.y, false, Image.FORMAT_RGBA8)
  image.fill_rect(Rect2(Vector2(0, 0), viewport), Color(1, 1, 1, 1))

  brush = Image.new()
  brush.load("res://art/mask_brush.png")

  brush_mask = Image.new()
  brush_mask.load("res://art/mask_brush_mask.png")

  refresh_texture()

  position = Vector2(viewport.x / 2, viewport.y / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _on_BodyMask_cut(position):
  """image.fill_rect(Rect2(
    Vector2(position.x - CUT_SIZE / 2, position.y - CUT_SIZE / 2),
    Vector2(CUT_SIZE, CUT_SIZE)),
    Color(0, 0, 0, 0))"""
  image.blit_rect_mask(
    brush,
    brush_mask,
    Rect2(Vector2(0, 0), Vector2(CUT_SIZE, CUT_SIZE)),
    Vector2(position.x - CUT_SIZE / 2, position.y - CUT_SIZE / 2))
  refresh_texture()
