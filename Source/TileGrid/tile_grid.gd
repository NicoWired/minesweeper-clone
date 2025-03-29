class_name TileGrid
extends GridContainer
## Grid representing the minesweeper board

# params
var grid_size: Vector2
var total_mines: int

# attributes
var board_state: Array[Array] = []
var total_flags: int = 0
var tile_size: int
var initialized: bool = false
@onready var tile_amt: int = int(grid_size.x * grid_size.y)

# signals
signal mine_hit
signal tile_pressed
signal tile_flagged
signal game_won


func initialize(init_grid_size: Vector2, int_mine_amt: int, init_tile_size: int) -> void:
	assert(int_mine_amt < int(init_grid_size.x * init_grid_size.y), "The amount of mines must be less than the amount of tiles")
	self.grid_size = init_grid_size
	self.tile_size = init_tile_size
	total_mines = int_mine_amt
	initialized = true

func _ready() -> void:
	assert(initialized, "Must run initialize() before adding this node to the scene tree")
	$RevealPlayer.stream = ExternalResourceLoader.sfx["reveal"]
	$MineHitPlayer.stream = ExternalResourceLoader.sfx["explosion"]
	$FlagPlayer.stream = ExternalResourceLoader.sfx["flag"]
	$UnflagPlayer.stream = ExternalResourceLoader.sfx["unflag"]
	columns = int(grid_size.x)
	board_init()
	setup_mines()
	find_adjacent_mines()
	create_tiles()

func board_init() -> void:
	for i in grid_size.x:
		var column: Array = []
		board_state.append(column)
		for j in grid_size.y:
			column.append({"mined": false, "explored": false})

func setup_mines() -> void:
	var all_coords: Array = []
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			all_coords.append(Vector2(x, y))
	all_coords.shuffle()
	for i in range(total_mines):
		var coord: Vector2 = all_coords[i]
		board_state[coord.x][coord.y]["mined"] = true

func create_tiles() -> void:
	var adjacent_mines: int
	var coords: Vector2
	var mined: bool
	for y in range(board_state[0].size()):
		for x in range(board_state.size()):
			mined = board_state[x][y]["mined"]
			adjacent_mines = board_state[x][y]["adjacent_mines"]
			coords = Vector2(x,y)
			var tile: Tile = ExternalResourceLoader.scenes["tile"].instantiate()
			tile.initialize(adjacent_mines, coords, mined, tile_size)
			board_state[x][y]["tile"] = tile
			tile.pressed.connect(on_tile_pressed)
			tile.two_buttons_click.connect(on_two_buttons_click)
			tile.tile_flagged.connect(on_tile_flagged)
			add_child(tile)

## Finds the amount of adjacent mines for each tile, unless the tile is mined
func find_adjacent_mines() -> void:
	for x in range(board_state.size()):
		for y in range(board_state[x].size()):
			var adjacent_mine_count: int = 0
			var adjacent_tiles: Array = find_adjacent_tiles(Vector2(x,y))
			for tile in adjacent_tiles:
				if board_state[tile.x][tile.y]["mined"]:
					adjacent_mine_count += 1
			board_state[x][y]["adjacent_mines"] = adjacent_mine_count

## Finds all the adjacent tiles that have not been explored
## Returns an array of Vector2 coordinates
func find_adjacent_tiles(coords: Vector2) -> Array:
	var adjacent_tiles: Array = []
	for x_offset in range(-1, 2):
		for y_offset in range(-1, 2):
			if x_offset == 0 and y_offset == 0:
				continue
			var new_x: int = int(coords.x) + x_offset
			var new_y: int = int(coords.y) + y_offset
			# check if the new coords are within bounds, and the tile has not been pressed
			if new_x >= 0 and new_y >= 0 and \
				new_x < board_state.size() and new_y < board_state[0].size()\
				and not board_state[new_x][new_y]["explored"]:
					adjacent_tiles.append(Vector2(new_x, new_y))
	return adjacent_tiles

## When a tile is pressed, it reveals the tile and checks if the game is won
## If the tile is mined, it reveals the mine and emits the mine_hit signal
## If the tile has no adjacent mines, it reveals all the adjacent tiles
func on_tile_pressed(tile: Tile) -> void:
	board_state[tile.coords.x][tile.coords.y]["explored"] = tile.explored
	tile.tile_sprite.texture = tile.revealed_sprite
	if not tile.mined:
		$RevealPlayer.play()
	tile_pressed.emit()
	if check_win_condition():
		game_won.emit()
	if tile.mined:
		tile.hit_sprite.visible = true
		$MineHitPlayer.play()
		mine_hit.emit()
	elif tile.adjacent_mines == 0:
		on_no_adjacents(tile.coords)

## Presses all the adjacent tiles if the pressed tile has no adjacent mines
func on_no_adjacents(coords: Vector2) -> void:
	for coord in find_adjacent_tiles(coords):
		board_state[coord.x][coord.y]["tile"].tile_pressed()

## When two buttons are clicked, checks if the amount of flags placed in the adjacent tiles is equal to the amount of adjacent mines
## If it is, it reveals all the adjacent tiles
func on_two_buttons_click(coords: Vector2) -> void:
	var flag_amt: int = 0
	var adjacent_coords: Array = find_adjacent_tiles(coords)
	for adjacent_coord in adjacent_coords:
		if board_state[adjacent_coord.x][adjacent_coord.y]["tile"].flagged:
			flag_amt += 1
	if flag_amt == board_state[coords.x][coords.y]["tile"].adjacent_mines:
		on_no_adjacents(coords)

## Emits the total amount of flags placed in order to update the mine counter
func on_tile_flagged(flagged: bool) -> void:
	if flagged:
		$FlagPlayer.play()
		total_flags += 1
	else:
		$UnflagPlayer.play()
		total_flags -= 1

	var mines_left: int
	if total_mines - total_flags >= 0:
		mines_left = total_mines - total_flags
	else:
		mines_left = 0
	tile_flagged.emit(mines_left)

## Every time a tile is pressed, checks if there's any tile that hasn't been explored and is not mined
## If there's no such tile, the game is won
func check_win_condition() -> bool:
	for column: Array in board_state:
		if column.any(func(state): return not (state["explored"] or state["mined"])):
			return false
	return true
