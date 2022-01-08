extends Node

const SAVE_PATH := "user://saved_game.tres"

var saved_game : SavedGame = null

onready var _timer := $Timer

func _ready():
	var directory := Directory.new()
	if directory.file_exists(SAVE_PATH):
		# Attempt to load the resource!
		# Ideally we don't let the load()-method crash when the Resource is corrupted!
		# Unfortunately I haven't been able to find a way 'validate' a Resource...
		var result := load(SAVE_PATH)
		if result is SavedGame:
			saved_game = result
		else:
			push_error("Failed to load existing database from Project Data Folder (" + SAVE_PATH + ").")
			saved_game = SavedGame.new()

	else:
		# Make a new resource!
		saved_game = SavedGame.new()

	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.start()

# Automatically save the loaded game to file when you quit the game!
func _exit_tree():
	save_game_to_file()

# Save the game every time the Timer finishes!
func _on_timer_timeout() -> void:
	save_game_to_file()

func save_game_to_file():
	print("Saving game to file")
	saved_game.unix_time = OS.get_unix_time()

	ResourceSaver.save(SAVE_PATH, saved_game)
	ResourceSaver.save("res://saved_game_debug.tres", saved_game)
