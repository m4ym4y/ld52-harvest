extends Light2D

signal cut(position)

var brush
var brush_mask
var image
var viewport
var rng = RandomNumberGenerator.new()

const CUT_SIZE = 20
const SAMPLE_SIZE = 100000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func refresh_texture():
  var tex = ImageTexture.new()
  tex.create_from_image(image)
  texture = tex

# Called when the node enters the scene tree for the first time.
func _ready():
  rng.randomize()

  viewport = Vector2(
  ProjectSettings.get_setting("display/window/size/width"),
  ProjectSettings.get_setting("display/window/size/height"))

  image = Image.new()
  image.create(viewport.x, viewport.y, false, Image.FORMAT_RGBA8)
  image.fill_rect(Rect2(Vector2(0, 0), viewport), Color(0, 0, 0, 0))

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
  image.blend_rect(
    brush_mask,
    Rect2(Vector2(0, 0), Vector2(CUT_SIZE, CUT_SIZE)),
    Vector2(position.x - CUT_SIZE / 2, position.y - CUT_SIZE / 2))
  refresh_texture()

func is_uncovered(organ):
  var texture = organ.frames.get_frame(organ.animation, organ.frame)
  var organ_image : Image = texture.get_data()
  var organ_base_size = organ_image.get_size()

  var scaled_organ_image = Image.new()
  scaled_organ_image.copy_from(organ_image)
  scaled_organ_image.resize(
      int(organ_base_size.x * organ.scale.x),
      int(organ_base_size.y * organ.scale.y))

  var position = organ.position - (scaled_organ_image.get_size() / 2)

  # put our organ image into an empty image at its position
  var test_image = Image.new()
  test_image.create(viewport.x, viewport.y, false, Image.FORMAT_RGBA8)
  test_image.blit_rect(scaled_organ_image, Rect2(Vector2(0, 0), scaled_organ_image.get_size()), position)

  # render that into another image, masked by our light
  var test_image_masked = Image.new()
  test_image_masked.create(viewport.x, viewport.y, false, Image.FORMAT_RGBA8)
  test_image_masked.blit_rect_mask(test_image, image, Rect2(Vector2(0, 0), test_image.get_size()), Vector2(0, 0))

  test_image.lock()
  test_image_masked.lock()

  # test_image.save_png('test_image.png')
  # test_image_masked.save_png('test_image_masked.png')

  var size = scaled_organ_image.get_size()
  var wh = size.x / 2
  var hh = size.y / 2

  var total = 0
  var matches = 0

  for x in range(position.x - wh, position.x + wh):
    for y in range(position.y - hh, position.y + hh):
      #  for n in SAMPLE_SIZE:
#    var x = rng.randi_range(position.x - wh, position.x + wh)
#    var y = rng.randi_range(position.y - hh, position.y + hh)
      total += 1
      if test_image.get_pixel(x, y) == test_image_masked.get_pixel(x, y):
        matches += 1

  var percent = float(matches) / float(total)
  return percent > 0.998
