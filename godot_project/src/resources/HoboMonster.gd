tool
class_name HoboMonster
extends HoboResource

func _init():
	add_property("name", "Hobo Monster")
	add_property("health_points", 10)
	add_property("attack_damage", 1)
	add_property("attack_speed", 1)
	add_property("currency_on_death", 1)

	add_property("texture", preload("res://textures/doghobo.png"))
