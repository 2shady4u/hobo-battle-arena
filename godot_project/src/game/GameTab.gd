extends Control
class_name GameTab

enum TYPE {
	BATTLE,
	STATS,
	TRAINING,
}

export(TYPE) var type := TYPE.BATTLE

signal tab_change_requested
