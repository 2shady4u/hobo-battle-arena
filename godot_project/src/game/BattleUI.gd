extends GameTab

const PLAYER_NAME := "{0} Hobo (that's you!)"
const HEALTH_BAR := "{0}/{1}"
const HOBO_MONSTERS := [
	preload("res://resources/hobo_monsters/DogHobo.tres"),
	preload("res://resources/hobo_monsters/LoveHobo.tres"),
	preload("res://resources/hobo_monsters/MonsterHobo.tres"),
	preload("res://resources/hobo_monsters/AmogusHobo.tres")
]

onready var _player_name_label := $MarginContainer/HB/PlayerVBox/NameLabel
onready var _player_health_label := $MarginContainer/HB/PlayerVBox/HealthLabel

onready var _monster_name_label := $MarginContainer/HB/MonsterVBox/NameLabel
onready var _monster_health_label := $MarginContainer/HB/MonsterVBox/HealthLabel

onready var _monster_sprite := $HoboMonster
onready var _player_sprite := $Player

onready var _player_cooldown_timer := $Player/CooldownTimer
onready var _monster_cooldown_timer := $HoboMonster/CooldownTimer

onready var _pimp_button := $MarginContainer/VB/PimpButton

onready var _respawn_timer := $RespawnTimer

var _monster : HoboMonster = null
var _monster_health := 0
var _player_health := 0

var _previous_max_health := 0

var saved_game : SavedGame = null

func _ready() -> void:
	randomize()

	var epithet : String = EPITHETS[randi() % EPITHETS.size()]
	epithet = epithet.capitalize()

	_player_name_label.text = PLAYER_NAME.format([epithet])

	_player_cooldown_timer.connect("timeout", self, "_on_player_cooldown_timeout")
	_monster_cooldown_timer.connect("timeout", self, "_on_monster_cooldown_timeout")

	_pimp_button.connect("pressed", self, "_on_pimp_button_pressed")

	_respawn_timer.connect("timeout", self, "_on_respawn_timer_timeout")

	saved_game = State.saved_game

	_spawn_player()
	_spawn_monster()

func _on_player_cooldown_timeout() -> void:
	_monster_health -= saved_game.get_player_attack_damage()
	if _monster_health <= 0:
		saved_game.currency += _monster.currency_on_death
		_despawn_monster()
		_respawn_timer.start()

	update_monster_health_label()

func _on_monster_cooldown_timeout() -> void:
	_player_health -= _monster.attack_damage
	if _player_health <= 0:
		pass

	update_player_health_label()

func _on_pimp_button_pressed() -> void:
	emit_signal("tab_change_requested", TYPE.STATS)

func _on_respawn_timer_timeout() -> void:
	_spawn_monster()

func _on_player_max_health_changed(player_max_health : int) -> void:
	# We have to recalculate the remaining health!
	var health_difference := player_max_health - _previous_max_health
	_player_health += health_difference
	_previous_max_health = player_max_health

	update_player_health_label()

func _spawn_player() -> void:
	var max_health : int = saved_game.get_player_max_health()
	_player_health = max_health
	update_player_health_label()

	_player_sprite.visible = true

func _spawn_monster() -> void:
	_monster = HOBO_MONSTERS[randi() % HOBO_MONSTERS.size()]

	_monster_sprite.texture = _monster.texture
	_monster_name_label.text = _monster.name

	var max_health : int = _monster.health_points
	_monster_health = max_health
	update_monster_health_label()

	_monster_sprite.visible = true
	_player_cooldown_timer.start()
	_monster_cooldown_timer.start()

func _despawn_monster():
	_monster_sprite.visible = false
	_player_cooldown_timer.stop()
	_monster_cooldown_timer.stop()

func update_monster_health_label() -> void:
	var max_health : int = _monster.health_points
	_monster_health_label.text = HEALTH_BAR.format([_monster_health, max_health])

func update_player_health_label() -> void:
	var max_health : int = saved_game.get_player_max_health()
	_player_health_label.text = HEALTH_BAR.format([_player_health, max_health])

const EPITHETS := [
	"pathetic",
	"mediocre",
	"simping",
	"hard-boiled",
]
