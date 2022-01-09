extends Control
class_name MutationBox

onready var name_label: Label = $Name
onready var price: Label = $Price
onready var buy_button: Button = $BuyButton

var actual_price = 0

var mutation_data = null

func _ready():
	State.saved_game.connect("currency_changed", self, "_on_currency_changed")
	State.saved_game.connect("upgrades_changed", self, "_on_upgrades_changed")
	buy_button.connect("pressed", self, "_on_buy_button_pressed")


func _on_upgrades_changed(new_upgrades_data):
	if mutation_data.name in new_upgrades_data:
		set_data(new_upgrades_data[mutation_data.name])

func set_data(data):
	mutation_data = data
	name_label.text = data.title

	var mutations = State.saved_game.upgrades

	if data.name in mutations:
		buy_button.text = "UPGRADE"
		var level = mutations[data.name].level
		actual_price = data.price * level
		price.text = get_formatted_price()

		name_label.text = "LV." + str(mutations[data.name].level) + " " + data.title
	else:
		buy_button.text = "BUY"
		actual_price = data.price / 2
		price.text = get_formatted_price()

	var currency = State.saved_game.currency
	if actual_price > currency:
		buy_button.disabled = true
	else:
		buy_button.disabled = false

func _on_currency_changed(new_currency):
	if actual_price > new_currency:
		buy_button.disabled = true
	else:
		buy_button.disabled = false

func _on_buy_button_pressed():
	State.saved_game.buy_mutation(mutation_data)
	State.saved_game.pay_currency(actual_price)


func get_formatted_price():
	if actual_price > 1_000_000_000:
		return "%3.1f" % (actual_price * 1.0 / 1_000_000_000) + "BS"
	if actual_price > 1_000_000:
		return "%3.1f" % (actual_price * 1.0 / 1_000_000) + "MS"
	if actual_price > 1_000:
		return "%3.1f" % (actual_price * 1.0 / 1_000) + "KS"
	return "%3d" % actual_price + "S"



