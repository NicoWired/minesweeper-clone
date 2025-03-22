class_name Tile
extends Control


# params
var tile_size: int
var adjacent_mines: int
var coords: Vector2
var mined: bool = false

# attributes
var explored: bool = false
var flagged: bool = false
var tile_sprite: Sprite2D = Sprite2D.new()
var hit_sprite: Sprite2D = Sprite2D.new()
#var revealed_sprite: Sprite2D = Sprite2D.new()
var revealed_sprite: CompressedTexture2D
var initialized: bool = false

# signals
signal pressed	# emitted when the tile is pressed with the left mouse button
signal two_buttons_click # emitted when the tile is pressed with both mouse buttons
signal tile_flagged # emitted when the tile is flagged or unflagged

func initialize(init_adjacent_mines: int, init_coords: Vector2, init_mined: bool, init_tile_size: int = 32) -> void:
	self.tile_size = init_tile_size
	self.adjacent_mines = init_adjacent_mines
	self.coords = init_coords
	self.mined = init_mined
	initialized = true

func _ready() -> void:
	assert(initialized, "Run initalize() before adding this node to the scene tree")
	set_revealed_sprite()
	custom_minimum_size = Vector2(tile_size, tile_size)
	tile_sprite.texture = ExternalResourceLoader.sprites["UNEXPLORED"]
	hit_sprite.texture = ExternalResourceLoader.sprites["HIT"]
	var texture_size: Vector2 = tile_sprite.texture.get_size()
	for sprite: Sprite2D in [tile_sprite, hit_sprite]:
		sprite.centered = false
		sprite.scale = Vector2(tile_size, tile_size) / texture_size
	hit_sprite.visible = false
	add_child(hit_sprite)
	add_child(tile_sprite)
	

func scale_sprite(sprite: Sprite2D) -> Sprite2D:
	var texture_size: Vector2 = sprite.texture.get_size()
	sprite.centered = false
	sprite.scale = Vector2(tile_size, tile_size) / texture_size
	return sprite

func set_revealed_sprite() -> void:
	if mined:
		revealed_sprite = ExternalResourceLoader.sprites["MINE"]
	else:
		revealed_sprite = ExternalResourceLoader.sprites["MINES_%s" % adjacent_mines]
	#revealed_sprite = scale_sprite(revealed_sprite)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and GameState.current_state == GameState.states.RUNNING:
		if event.is_pressed() and not explored:
			if event.button_index == MOUSE_BUTTON_LEFT and not flagged:
				tile_pressed()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if flagged:
					tile_sprite.texture = ExternalResourceLoader.sprites["UNEXPLORED"]
				else:
					tile_sprite.texture = ExternalResourceLoader.sprites["FLAG"]
				flagged = !flagged
				tile_flagged.emit(flagged)
		elif event.is_pressed() and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and explored:
			two_buttons_click.emit(coords)

func tile_pressed() -> void:
	if not flagged:
		explored = true
		pressed.emit(self)
