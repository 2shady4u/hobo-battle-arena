tool
class_name HoboResource
extends Resource

# NOTE: NEVER add new keys directly to this Dictionary!
# Use the 'add_property()'-method instead!
var settings_dict := {}

func add_property(key : String, value) -> void:
	settings_dict[key] = value
	if not Engine.editor_hint:
		# Every property gets its own signal
		add_user_signal(key + "_changed")

func _set(property : String, value) -> bool:
	if settings_dict.has(property):
		settings_dict[property] = value
		if not Engine.editor_hint:
			emit_signal(property + "_changed", value)

		return true
	else:
		return false

func _get(property : String):
	if settings_dict.has(property):
		return settings_dict[property]
	else:
		return null

func _get_property_list():
	var property_list := []

	for key in settings_dict.keys():
		var value = settings_dict[key]
		property_list.append({"name": key, "type": typeof(value)})

	return property_list

func connect_node_to_setting(property : String, node : Node, method : String):
	connect(property + "_changed", node, method)
