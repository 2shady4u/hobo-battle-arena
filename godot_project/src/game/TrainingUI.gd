extends GameTab

onready var _training_control = $MC/VB/TrainingControl/MC/Training
onready var _not_training_control = $MC/VB/TrainingControl/MC/NoTraining

onready var _buy_button = $MC/VB/TrainingControl/MC/NoTraining/VB/CoachBar/BuyButton
onready var _cancel_button = $MC/VB/TrainingControl/MC/Training/VB/CancelButton

onready var _battle_button := $MC/VB/ButtonHBox/BattleButton
onready var _stats_button := $MC/VB/ButtonHBox/StatsButton

func _ready() -> void:
	State.saved_game.connect("training_changed", self, "_on_training_changed")
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	State.saved_game.connect("coach_changed", self, "_on_coach_changed")
	_buy_button.connect("pressed", self, "_on_buy_coach_button")
	_cancel_button.connect("pressed", self, "_on_cancel_training_button_pressed")

	var coach = State.saved_game.coach
	_on_coach_changed(coach)
	_on_currency_changed(State.saved_game.currency)
	_on_training_changed(State.saved_game.training)

	_battle_button.connect("pressed", self, "_on_battle_button_pressed")
	_stats_button.connect("pressed", self, "_on_stats_button_pressed")

func _on_coach_changed(new_coach) -> void:
	if new_coach == 0:
		$MC/VB/TrainingControl/MC/NoTraining/VB/CoachBar/CoachName.text = "NO COACH"
		_buy_button.text = "HIRE COACH"
		$MC/VB/TrainingControl/MC/NoTraining/VB/TrainingOptions.hide()
	else:
		$MC/VB/TrainingControl/MC/NoTraining/VB/CoachBar/CoachName.text = "LV." + str(new_coach) + " COACH"
		_buy_button.text = "UPGRADE COACH"
		$MC/VB/TrainingControl/MC/NoTraining/VB/TrainingOptions.show()

func get_coach_price() -> int:
	return (100 + 1100 * State.saved_game.coach) * pow(1.6, State.saved_game.coach)

func _on_currency_changed(new_currency) -> void:
	var coach_price = get_coach_price()
	if new_currency > coach_price:
		_buy_button.disabled = false
	else:
		_buy_button.disabled = true

func _on_buy_coach_button() -> void:
	State.saved_game.upgrade_coach()
	State.saved_game.pay_currency(get_coach_price())

func _on_training_changed(training : Dictionary) -> void:
	if training.empty():
		_training_control.hide()
		_not_training_control.show()
	else:
		_training_control.show()
		_not_training_control.hide()

func _on_battle_button_pressed() -> void:
	emit_signal("tab_change_requested", TYPE.BATTLE)

func _on_stats_button_pressed() -> void:
	emit_signal("tab_change_requested", TYPE.STATS)

func _on_cancel_training_button_pressed() -> void:
	State.saved_game.set_training(null)

func _process(_delta : float) -> void:
	var training_in_progress : Dictionary = State.saved_game.training

	if not training_in_progress.empty():
		var now = OS.get_unix_time()
		var percentage = (now - training_in_progress.start) / training_in_progress.duration
		$MC/VB/TrainingControl/MC/Training/VB/VB/ProgressBar.value = percentage * 100
		$MC/VB/TrainingControl/MC/Training/VB/VB/RemainingTime.text = str(training_in_progress.duration - (now - training_in_progress.start)) + " sec REMAINING."
