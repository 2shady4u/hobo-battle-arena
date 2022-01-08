extends Control
class_name GameTab

enum TYPE {
	BATTLE,
	CHARACTER,
}

export(TYPE) var type := TYPE.BATTLE

signal tab_change_requested
