extends Node
## Singleton to keep track of the current game state

enum states {
	RUNNING,
	OVER
}

var current_state: int
