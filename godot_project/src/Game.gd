extends Control

onready var _tab_container := $TabContainer

func _ready() -> void:
	for child in _tab_container.get_children():
		if child is GameTab:
			child.connect("tab_change_requested", self, "_on_tab_change_requested")

func _on_tab_change_requested(type : int) -> void:
	for tab_idx in _tab_container.get_tab_count():
		var tab = _tab_container.get_tab_control(tab_idx)

		if tab is GameTab and tab.type == type:
			_tab_container.current_tab = tab_idx
			break
