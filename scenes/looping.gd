extends TileMap

export var VELOCITY: float = -1.5
var bounds: Rect2 = Rect2()

func _ready() -> void:
	bounds = calculate_bounds()
	
func _process(delta: float) -> void:
	position.x += VELOCITY
	_attempt_reposition()
	
func _attempt_reposition() -> void:
	if position.x <= -bounds.size.x:
		# Don't just reset position texture width, otherwise there will be a gap
		position.x += bounds.size.x*2

func calculate_bounds():
	var cell_bounds = self.get_used_rect()
	# create transform
	var cell_to_pixel = Transform2D(Vector2(self.cell_size.x * self.scale.x, 0), Vector2(0, self.cell_size.y * self.scale.y), Vector2())
	# apply transform
	return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)
