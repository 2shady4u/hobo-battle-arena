tool
class_name HoboMonster
extends HoboResource

func _init():
	add_property("name", "")
	add_property("health_points", 0)
	add_property("attack_damage", 0)
	add_property("attack_speed", 0)

	add_property("texture", preload("res://textures/doghobo.png"))
