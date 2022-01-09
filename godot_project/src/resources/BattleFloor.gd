tool
class_name BattleFloor
extends HoboResource

func _init():
	add_property("name", "Sewer Floor")
	add_property("monsters", [])

func get_random_monster() -> HoboMonster:
	var monsters : Array = settings_dict.get("monsters", [])
	if monsters.empty():
		push_error("There's no monsters on this floor?!")
		return null
	else:
		return monsters[randi() % monsters.size()]
