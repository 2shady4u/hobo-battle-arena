extends Label

const CURRENCY_LABEL := "Used syringes: {0}"

func _ready():
	var saved_game = State.saved_game
	saved_game.connect_node_to_setting("currency", self, "_on_currency_changed")
	_on_currency_changed(saved_game.currency)

func _on_currency_changed(currency : int) -> void:
	text = CURRENCY_LABEL.format([currency])
