extends HBoxContainer

@onready var keybind_label: Label = $KeybindLabel
@onready var keybind_button: Button = $KeybindButton

var action_name: String

func _ready() -> void:
	set_process_unhandled_input(false)

func setup(p_action_name: String, display_name: String) -> void:
	action_name = p_action_name
	keybind_label.text = display_name
	_update_key_text()

func _update_key_text() -> void:
	var events := InputMap.action_get_events(action_name)
	if events.size() > 0:
		keybind_button.text = events[0].as_text().trim_suffix(" (Physical)")
	else:
		keybind_button.text = "Unbound"

func _on_keybind_button_pressed() -> void:
	keybind_button.text = "Press a key..."
	keybind_button.release_focus()
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		get_viewport().set_input_as_handled()
		set_process_unhandled_input(false)

		if event.keycode != KEY_ESCAPE:
			SettingsManager.remap_action(action_name, event)

		_update_key_text()
