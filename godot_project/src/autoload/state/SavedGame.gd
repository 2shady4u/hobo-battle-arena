tool
class_name SavedGame
extends HoboResource

func _init():
	add_property("currency", 500)
	add_property("unix_time", OS.get_unix_time())
	add_property("upgrades", {}) # contains bought mutations and completed trainings
	add_property("training", {})
	add_property("coach", 0)
	add_property("floor_index", 0)

func get_player_max_health() -> int:
	# TODO: Add some crazy algorithm that calculates the player's max health!
	return get_stat_value("hp")

func get_player_attack_damage() -> int:
	# TODO: Add some crazy algorithm that calculates the player's attack damage
	return get_stat_value("atk")

func get_player_attack_speed() -> int:
	# TODO: Add some crazy algorithm that calculates the player's attack speed
	return 1

func get_floor() -> BattleFloor:
	var current_floor : BattleFloor = load("res://resources/battle_floors/TheRedGutter.tres")
	return current_floor

func get_stats() -> Dictionary:
	var stats = {
		"atk": 5, # attack
		"def": 3, # current defense (skip?)
		"hp": 100, # max_health
		"spd": 3, # speed
		"regen": 2, # regeneration,
		"abs": 1, # multiplier on syringes you collect?
	}
	var upgrades = _get("upgrades")

	# first apply raw cumulative mutations
	for upgrade in upgrades:
		var upgrade_data = upgrades[upgrade]
		if upgrade_data.type == "mutation":
			for stat in upgrade_data.stats:
				stats[stat] += upgrade_data.stats[stat] * upgrade_data.level

	# then apply multiplicative training
	for upgrade in upgrades:
		var upgrade_data = upgrades[upgrade]
		if upgrade_data.type == "training":
			for stat in upgrade_data.stats:
				stats[stat] *= pow(upgrade_data.stats[stat], upgrade_data.level)

	return stats

func get_stat_value(stat_name: String) -> int:
	var stats = get_stats()
	return stats[stat_name]

func get_player_currency() -> int:
	return _get("currency")

func increase_currency(value = 50):
	_set("currency", _get("currency") + value)

func buy_mutation(mutation: Dictionary):
	var upgrades = _get("upgrades")
	if mutation.name in upgrades:
		upgrades[mutation.name].level = upgrades[mutation.name].level + 1
	else:
		upgrades[mutation.name] = mutation
		upgrades[mutation.name].type = "mutation"
		upgrades[mutation.name].level = 1

	self.upgrades = upgrades

func pay_currency(value: int):
	self.currency = max(self.currency - value, 0)

func upgrade_coach():
	self.coach = self.coach + 1

func finish_training():
	var training : Dictionary = _get("training")
	if not training.empty():
		var upgrade_name = training.type + "_training"

		var upgrades = _get("upgrades")
		if upgrade_name in upgrades:
			upgrades[upgrade_name].level = upgrades[upgrade_name].level + 1
		else:
			upgrades[upgrade_name] = {
				"stats": {
					training: 1.1,
				},
				"level": 1,
				"type": "training"
			}

		self.upgrades = upgrades
		self.training.clear()
