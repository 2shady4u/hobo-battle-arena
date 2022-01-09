extends GameTab


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var training = $Panel/Training
onready var not_training = $Panel/NoTraining

onready var buy_button = $Panel/NoTraining/CoachBar/BuyButton
onready var cancel_training_button = $Panel/Training/CancelTraining


# Called when the node enters the scene tree for the first time.
func _ready():
	State.saved_game.connect("training_changed", self, "_on_training_changed")
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	State.saved_game.connect("coach_changed", self, "_on_coach_changed")
	buy_button.connect("pressed", self, "_on_buy_coach_button")
	cancel_training_button.connect("pressed", self, "_on_cancel_training_button_pressed")

	var coach = State.saved_game.get_player_coach()
	_on_coach_changed(coach)
	_on_currency_changed(State.saved_game.get_player_currency())
	_on_training_changed(State.saved_game.get_player_training())

func _on_coach_changed(new_coach):
	if new_coach == 0:
		$Panel/NoTraining/CoachBar/CoachName.text = "NO COACH"
		$Panel/NoTraining/CoachBar/BuyButton.text = "HIRE COACH"
		$Panel/NoTraining/TrainingOptions.hide()
	else:
		$Panel/NoTraining/CoachBar/CoachName.text = "LV." + str(new_coach) + " COACH"
		$Panel/NoTraining/CoachBar/BuyButton.text = "UPGRADE COACH"
		$Panel/NoTraining/TrainingOptions.show()

func _on_currency_changed(new_currency):
	var coach_price = (100 + 1100 * State.saved_game.get_player_coach()) * pow(1.6, State.saved_game.get_player_coach())
	if new_currency > coach_price:
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func _on_buy_coach_button():
	State.saved_game.upgrade_coach()

func _on_training_changed(new_training):
	if new_training != null:
		training.show()
		not_training.hide()
	else:
		training.hide()
		not_training.show()

func _on_cancel_training_button_pressed():
	State.saved_game.set_training(null)

func _process(true):
	var training_in_progress = State.saved_game.get_player_training()

	if training_in_progress:
		var now = OS.get_unix_time()
		var percentage = (now - training_in_progress.start) / training_in_progress.duration
		$Panel/Training/ProgressBar.value = percentage * 100
		$Panel/Training/ProgressBar/RemainingTime.text = str(training_in_progress.duration - (now - training_in_progress.start)) + " sec REMAINING."

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
