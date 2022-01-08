extends GameTab

const PLAYER_NAME := "{0} Hobo (that's you!)"
const HEALTH_BAR := "{0}/{1}"

onready var _player_name_label := $MarginContainer/HB/PlayerVBox/NameLabel
onready var _player_health_label := $MarginContainer/HB/PlayerVBox/HealthLabel

onready var _monster_name_label := $MarginContainer/HB/MonsterVBox/NameLabel
onready var _monster_health_label := $MarginContainer/HB/MonsterVBox/HealthLabel

onready var _monster_sprite := $HoboMonster

onready var _player_cooldown_timer := $Player/CooldownTimer
onready var _monster_cooldown_timer := $HoboMonster/CooldownTimer

onready var _respawn_timer := $RespawnTimer

var monster : HoboMonster = load("res://resources/hobo_monsters/DogHobo.tres")
var monster_health := 0

func _ready() -> void:
	randomize()

	var epithet : String = EPITHETS[randi() % EPITHETS.size()]
	epithet = epithet.capitalize()

	_player_name_label.text = PLAYER_NAME.format([epithet])

	_player_cooldown_timer.connect("timeout", self, "_on_player_cooldown_timeout")
	_monster_cooldown_timer.connect("timeout", self, "_on_monster_cooldown_timeout")
	_respawn_timer.connect("timeout", self, "_on_respawn_timer_timeout")

	_spawn_monster()

func _on_player_cooldown_timeout() -> void:
	monster_health -= 1
	if monster_health <= 0:
		_despawn_monster()
		_respawn_timer.start()

	update_monster_health_label()

func _on_monster_cooldown_timeout() -> void:
	pass

func _on_respawn_timer_timeout() -> void:
	_spawn_monster()

func _spawn_monster() -> void:
	_monster_sprite.texture = monster.texture
	_monster_name_label.text = monster.name

	var max_health_points : int = monster.health_points
	monster_health = max_health_points
	update_monster_health_label()

	_monster_sprite.visible = true
	_player_cooldown_timer.start()
	_monster_cooldown_timer.start()

func _despawn_monster():
	_monster_sprite.visible = false
	_player_cooldown_timer.stop()
	_monster_cooldown_timer.stop()

func update_monster_health_label() -> void:
	var max_health_points : int = monster.health_points
	_monster_health_label.text = HEALTH_BAR.format([monster_health, max_health_points])

const EPITHETS := [
	"pathetic",
	"mediocre",
	"simping",
	"hard-boiled",
]
