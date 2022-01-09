extends GameTab

const mutation_scene = preload("res://src/game/stats_ui/Mutation.tscn")
const stat_scene = preload("res://src/game/stats_ui/Stat.tscn")

onready var _stats_vbox = $MC/VB/ContentHBox/StatControl/MC/StatsVBox
onready var _mutation_vbox = $MC/VB/ContentHBox/MutationControl/MC/VB/MutationVBox

onready var _currency_label := $MC/VB/ContentHBox/MutationControl/MC/VB/CurrencyLabel

onready var _battle_button := $MC/VB/ButtonHBox/BattleButton
onready var _training_button := $MC/VB/ButtonHBox/TrainingButton

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

func _ready():
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	for stat in stats:
		var stat_instance = stat_scene.instance()
		_stats_vbox.add_child(stat_instance)
		stat_instance.set_stat(stat)

	for mutation in mutations:
		var mutation_instance = mutation_scene.instance()
		_mutation_vbox.add_child(mutation_instance)
		mutation_instance.set_data(mutation)

	_currency_label.text = get_formatted_money(State.saved_game.currency)

	_battle_button.connect("pressed", self, "_on_battle_button_pressed")
	_training_button.connect("pressed", self, "_on_training_button_pressed")

func _on_currency_changed(currency):
	_currency_label.text = get_formatted_money(currency)

func _on_battle_button_pressed():
	emit_signal("tab_change_requested", TYPE.BATTLE)

func _on_training_button_pressed():
	emit_signal("tab_change_requested", TYPE.TRAINING)

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
