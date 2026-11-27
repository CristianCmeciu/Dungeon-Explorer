extends Node

const SAVE_PATH := "user://settings.cfg"

const REMAPPABLE_ACTIONS: Dictionary = {
	"attack": "Attack/Take Item/Save Minion/Play Again",
	"defend": "Defend/Take Gold/Main Menu",
	"door_left" : "Go To Left Door",
	"door_front": "Go To Front Door",
	"door_right": "Go To Right Door"
}

var config := ConfigFile.new()

func _ready() -> void:
	load_settings()

func set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_value))
	AudioServer.set_bus_mute(bus_idx, linear_value <= 0.001)
	config.set_value("audio", bus_name, linear_value)

func get_bus_volume(bus_name: String) -> float:
	return config.get_value("audio", bus_name, 1.0)

func remap_action(action_name: String, new_event: InputEvent) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)
	config.set_value("controls", action_name, new_event)

func save_settings() -> void:
	config.save(SAVE_PATH)

func load_settings() -> void:
	if config.load(SAVE_PATH) != OK:
		return

	for bus_name in ["Master", "Music", "SFX"]:
		set_bus_volume(bus_name, get_bus_volume(bus_name))

	for action_name in REMAPPABLE_ACTIONS.keys():
		if config.has_section_key("controls", action_name):
			var saved_event: InputEvent = config.get_value("controls", action_name)
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(action_name, saved_event)
