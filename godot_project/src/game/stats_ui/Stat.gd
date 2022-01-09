extends Control
class_name StatBox

onready var stat = $Stat
onready var value = $Value

export var stat_name = "str"

func _ready():
	stat.text = stat_name.to_upper()
	State.saved_game.connect("upgrades_changed", self, "_on_upgrades_changed")

func set_stat(_stat_name: String):
	stat_name = _stat_name
	stat.text = stat_name.to_upper()
	value.text = str(State.saved_game.get_stat_value(stat_name))

func _on_upgrades_changed(new_upgrades):
	value.text = str(State.saved_game.get_stat_value(stat_name))
