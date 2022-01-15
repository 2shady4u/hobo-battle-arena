extends Label

const HOBO_COUNT := "{0} Hobos: {1}/10"

var kill_count := 0 setget set_kill_count
func set_kill_count(value : int) -> void:
	kill_count = value
	update_label()

var _synonym := ""

func _ready():
	_synonym = DEFEATED_SYNONYMS[randi() % DEFEATED_SYNONYMS.size()]
	_synonym = _synonym.capitalize()
	update_label()

func update_label() -> void:
	text = HOBO_COUNT.format([_synonym, kill_count])

const DEFEATED_SYNONYMS := [
	"smashed",
	"pwned",
	"yeeted",
	"fubar'd",
	"served",
	"tickled"
]
