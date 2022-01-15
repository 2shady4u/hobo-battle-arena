extends Label

const FLOOR_LABEL := "{0} (Floor {1})"

var saved_game : SavedGame = null

func _ready():
	saved_game = State.saved_game
	saved_game.connect_node_to_setting("floor_index", self, "_on_floor_index_changed")
	_on_floor_index_changed(saved_game.floor_index)

func _on_floor_index_changed(floor_index : int) -> void:
	var current_floor : BattleFloor = saved_game.get_floor()
	var floor_name : String = current_floor.name

	text = FLOOR_LABEL.format([floor_name, floor_index])
