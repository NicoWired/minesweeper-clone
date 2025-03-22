extends Node
## Singleton to load resources from the project

var sprites: Dictionary
var sfx: Dictionary
var scenes: Dictionary
var bgm: AudioStreamMP3

func _ready() -> void:
	# Load sprites
	sprites["UNEXPLORED"] = preload("res://Assets/Minesweeper_LAZARUS_61x61_unexplored.png")
	sprites["FLAG"] = preload("res://Assets/Minesweeper_LAZARUS_61x61_flag.png")
	sprites["MINE"] = preload("res://Assets/Minesweeper_LAZARUS_61x61_mine_transparent.png")
	sprites["HIT"] = preload("res://Assets/Minesweeper_LAZARUS_61x61_mine_hit.png")
	for i in range(9):
		sprites["MINES_%s" % i] = load("res://Assets/Minesweeper_LAZARUS_61x61_%s.png" % i)

	# Load SFX
	sfx["explosion"] = preload("res://Assets/SFX/JDSherbert - Pixel Explosions SFX Pack - Explosion (Large - 2).mp3")
	sfx["reveal"] = preload("res://Assets/SFX/Text 1.wav")
	
	# Load BGM
	bgm = preload("res://Assets/Music/happy_adveture.mp3")

	# Scene paths
	scenes["tile_grid"] = preload("res://Components/TileGrid/tile_grid.tscn")
	scenes["tile"] = preload("res://Components/Tile/tile.tscn")
