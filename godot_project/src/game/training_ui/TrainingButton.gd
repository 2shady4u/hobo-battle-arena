extends VBoxContainer

onready var button = $Button
onready var duration_label = $Duration

export(String, "atk", "def", "spd", "regen", "abs", "hp") var training = "atk"

func _ready():
	State.saved_game.connect("upgrades_changed", self, "_on_upgrades_updated")
	State.saved_game.connect("coach_changed", self, "_on_coach_updated")

	button.connect("pressed", self, "_on_button_pressed")

	update_training(State.saved_game.upgrades)

func _on_upgrades_updated(new_upgrades):
	update_training(new_upgrades)

func _on_coach_updated(_new_coach):
	update_training(State.saved_game.upgrades)

func update_training(upgrades):
	var coach = State.saved_game.coach

	if coach == 0:
		hide()
	else:
		show()

	button.text = training.to_upper()
	var string = training + "_training"
	if string in upgrades:
		button.text = "LV." + str(upgrades[string].level) + " " + training.to_upper() + ""
	else:
		button.text = training.to_upper() + ""
	duration_label.text = str(get_duration()) + " sec."

func get_duration():
	var upgrades = State.saved_game.upgrades
	var coach = State.saved_game.coach
	var string = training + "_training"
	if string in upgrades:
		return 100.0 * (pow(1.8, upgrades[string].level)) / pow(2, coach)
	else:
		return 15.0

func _on_button_pressed():
	State.saved_game.training = {
		"type": training,
		"start": OS.get_unix_time(),
		"duration": get_duration()
	}

func _process(_delta : float):
	var training_in_progress : Dictionary = State.saved_game.training

	if not training_in_progress.empty():
		if training_in_progress.type == training:
			var now = OS.get_unix_time()
			if now > training_in_progress.start + training_in_progress.duration:
				State.saved_game.finish_training()

