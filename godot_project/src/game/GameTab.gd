extends Control
class_name GameTab

enum TYPE {
	BATTLE,
	STATS,
	TRAINING,
}

export(TYPE) var type := TYPE.BATTLE

# warning-ignore:unused_signal
signal tab_change_requested
