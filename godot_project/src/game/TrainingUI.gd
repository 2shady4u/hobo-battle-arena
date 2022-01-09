extends GameTab

onready var _training_panel = $Panel/Training
onready var _not_training_panel = $Panel/NoTraining

onready var buy_button = $Panel/NoTraining/CoachBar/BuyButton
onready var cancel_training_button = $Panel/Training/CancelTraining

func _ready() -> void:
	State.saved_game.connect("training_changed", self, "_on_training_changed")
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	State.saved_game.connect("coach_changed", self, "_on_coach_changed")
	buy_button.connect("pressed", self, "_on_buy_coach_button")
	cancel_training_button.connect("pressed", self, "_on_cancel_training_button_pressed")

	var coach = State.saved_game.coach
	_on_coach_changed(coach)
	_on_currency_changed(State.saved_game.currency)
	_on_training_changed(State.saved_game.training)

func _on_coach_changed(new_coach) -> void:
	if new_coach == 0:
		$Panel/NoTraining/CoachBar/CoachName.text = "NO COACH"
		$Panel/NoTraining/CoachBar/BuyButton.text = "HIRE COACH"
		$Panel/NoTraining/TrainingOptions.hide()
	else:
		$Panel/NoTraining/CoachBar/CoachName.text = "LV." + str(new_coach) + " COACH"
		$Panel/NoTraining/CoachBar/BuyButton.text = "UPGRADE COACH"
		$Panel/NoTraining/TrainingOptions.show()

func get_coach_price() -> int:
	return (100 + 1100 * State.saved_game.coach) * pow(1.6, State.saved_game.coach)

func _on_currency_changed(new_currency) -> void:
	var coach_price = get_coach_price()
	if new_currency > coach_price:
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func _on_buy_coach_button() -> void:
	State.saved_game.upgrade_coach()
	State.saved_game.pay_currency(get_coach_price())

func _on_training_changed(training : Dictionary) -> void:
	if training.empty():
		_training_panel.hide()
		_not_training_panel.show()
	else:
		_training_panel.show()
		_not_training_panel.hide()

func _on_cancel_training_button_pressed() -> void:
	State.saved_game.set_training(null)

func _process(_delta : float) -> void:
	var training_in_progress : Dictionary = State.saved_game.training

	if not training_in_progress.empty():
		var now = OS.get_unix_time()
		var percentage = (now - training_in_progress.start) / training_in_progress.duration
		$Panel/Training/ProgressBar.value = percentage * 100
		$Panel/Training/ProgressBar/RemainingTime.text = str(training_in_progress.duration - (now - training_in_progress.start)) + " sec REMAINING."
