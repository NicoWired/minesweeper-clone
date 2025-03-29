extends Node
## Singleton to load resources from the project

var sprites: Dictionary
var sfx: Dictionary
var scenes: Dictionary
var bgm: AudioStreamMP3

func _ready() -> void:
	# Load sprites
	sprites["UNEXPLORED"] = preload("res://Assets/Sprites/UI_Flat_FrameSlot02a.png")
	sprites["FLAG"] = preload("res://Assets/Sprites/UI_Flat_FrameSlot02a_flag.png")
	sprites["MINE"] = preload("res://Assets/Sprites/Minesweeper_LAZARUS_61x61_mine_transparent.png")
	sprites["HIT"] = preload("res://Assets/Sprites/Minesweeper_LAZARUS_61x61_mine_hit.png")
	for i in range(9):
		sprites["MINES_%s" % i] = load("res://Assets/Sprites/Minesweeper_LAZARUS_61x61_%s.png" % i)

	# Load SFX
	sfx["explosion"] = preload("res://Assets/SFX/Attack - Explosion 02.wav")
	sfx["reveal"] = preload("res://Assets/SFX/UI - Text 01.wav")
	sfx["flag"] = preload("res://Assets/SFX/UI - Button 01.wav")
	sfx["unflag"] = preload("res://Assets/SFX/UI - Button Cancel 1.wav")
	
	# Load BGM
	bgm = preload("res://Assets/Music/happy_adveture.mp3")

	# Scene paths
	scenes["tile_grid"] = preload("res://Source/TileGrid/tile_grid.tscn")
	scenes["tile"] = preload("res://Source/Tile/tile.tscn")
