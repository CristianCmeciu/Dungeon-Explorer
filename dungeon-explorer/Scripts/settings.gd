extends Node2D

const KEYBIND_ROW_SCENE: PackedScene = preload("res://Scenes/keybind_row.tscn")

@onready var master_slider: HSlider = $SettingsContainer/VolumeMasterContainer/MasterSlider
@onready var music_slider: HSlider = $SettingsContainer/VolumeMusicContainer/MusicSlider
@onready var sfx_slider: HSlider = $SettingsContainer/VolumeSFXContainer/SFXSlider
@onready var controls_container: VBoxContainer = $SettingsContainer/KeybindsContainer

var _is_dragging_sfx: bool = false

func _ready() -> void:
	_setup_slider(master_slider, "Master")
	_setup_slider(music_slider, "Music")
	_setup_slider(sfx_slider, "SFX")
	
	sfx_slider.drag_started.connect(func():
		_is_dragging_sfx = true
	)
	sfx_slider.drag_ended.connect(func(has_changed: bool):
		_is_dragging_sfx = false
		if has_changed:
			AudioManager.play_random_sfx()
	)
	sfx_slider.value_changed.connect(func(_val: float):
		if not _is_dragging_sfx:
			AudioManager.play_random_sfx()
	)

	for action_name in SettingsManager.REMAPPABLE_ACTIONS:
		var row = KEYBIND_ROW_SCENE.instantiate()
		controls_container.add_child(row)
		row.setup(action_name, SettingsManager.REMAPPABLE_ACTIONS[action_name])

func _setup_slider(slider: HSlider, bus_name: String) -> void:
	slider.min_value = 0.0
	slider.max_value = 2.0
	slider.step = 0.05
	slider.value = SettingsManager.get_bus_volume(bus_name)
	slider.value_changed.connect(func(val: float):
		SettingsManager.set_bus_volume(bus_name, val)
	)

func _on_close_button_pressed() -> void:
	SettingsManager.save_settings()
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
