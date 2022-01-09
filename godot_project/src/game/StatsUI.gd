extends GameTab

const mutation_scene = preload("res://src/game/stats_ui/Mutation.tscn")
const stat_scene = preload("res://src/game/stats_ui/Stat.tscn")

onready var stats_box = $StatsPanel/VBoxContainer
onready var mutation_box = $MutationPanel/VBoxContainer

var mutations = [
	{
		"name": "arms",
		"title": "Gangreen Armz",
		"price": 15,
		"rate": 1.8,
		"stats": {
			"atk": 2,
			"def": 1
		}
	},{
		"name": "legs",
		"title": "Gangreen Legz",
		"price": 100,
		"rate": 1.9,
		"stats": {
			"hp": 20,
			"spd": 2,
		}
	},{
		"name": "head",
		"title": "Gangreen Headz",
		"price": 600,
		"stats": {
			"hp": 15,
			"atk": 2,
			"spd": 2,
		}
	},{
		"name": "butt",
		"title": "Gangreen Buttz",
		"price": 3000,
		"rate": 2.25,
		"stats": {
			"def": 20,
		}
	},{
		"name": "pp",
		"title": "Big PP",
		"price": 1000000,
		"rate": 2.4,
		"stats": {
			"def": 10,
		}
	}
]

var stats = ["hp", "atk", "def", "spd", "regen", "abs"]

# Called when the node enters the scene tree for the first time.
func _ready():
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	for stat in stats:
		var stat_instance = stat_scene.instance()
		stats_box.add_child(stat_instance)
		stat_instance.set_stat(stat)

	for mutation in mutations:
		var mutation_instance = mutation_scene.instance()
		mutation_box.add_child(mutation_instance)
		mutation_instance.set_data(mutation)

	$Currency.text = get_formatted_money(State.saved_game.currency)

func _on_currency_changed(currency):
	$Currency.text = get_formatted_money(currency)

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		State.saved_game.increase_currency(50)

static func get_formatted_money(money: int):
	if money > 1_000_000_000:
		return "%3.2f" % (money * 1.0 / 1_000_000_000) + "BS"
	if money > 1_000_000:
		return "%3.2f" % (money * 1.0 / 1_000_000) + "MS"
	if money > 1_000:
		return "%3.2f" % (money * 1.0 / 1_000) + "KS"
	return "%3d" % money + "S"
