tool
class_name SavedGame
extends HoboResource

func _init():
	add_property("currency", 0)
	add_property("unix_time", OS.get_unix_time())

func get_player_max_health() -> int:
	# TODO: Add some crazy algorithm that calculates the player's max health!
	return 100

func get_player_attack_damage() -> int:
	# TODO: Add some crazy algorithm that calculates the player's attack damage
	return 2

func get_player_attack_speed() -> int:
	# TODO: Add some crazy algorithm that calculates the player's attack speed
	return 1
