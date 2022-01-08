extends GameTab


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var mutation_scene = preload("res://src/game/StatsUI/Mutation.tscn")
onready var stat_scene = preload("res://src/game/StatsUI/Stat.tscn")

onready var stats_box = $StatsPanel/VBoxContainer
onready var mutation_box = $MutationPanel/VBoxContainer

var mutations = [
	{
		"name": "Gangreen armz"
	}
]

var stats = [
	"hp", "atk", "def", "regen"
]



# Called when the node enters the scene tree for the first time.
func _ready():
	for stat in stats:
		var stat_instance: StatBox = stat_scene.instance()
		stats_box.add_child(stat_instance)
		stat_instance.set_stat(stat)

	for mutation in mutations:
		var mutation_instance: MutationBox = mutation_scene.instance()
		mutation_box.add_child(mutation_instance)
		mutation_instance.set_data(mutation)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
