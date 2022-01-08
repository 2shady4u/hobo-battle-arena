extends Control
class_name StatBox

onready var stat = $Stat
onready var value = $Value

export var stat_name = "str"


func _ready():
	stat.text = stat_name.to_upper()

func set_stat(_stat_name: String):
	stat_name = _stat_name



