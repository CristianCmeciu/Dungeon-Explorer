extends Node2D

@onready var play_button: Button = $PlayButton
@onready var settings_button: Button = $PlayButton
@onready var compendium_button: Button = $PlayButton
@export var main: Node
const SETTINGS_SCENE: PackedScene = preload("res://Scenes/settings.tscn")

func _ready() -> void:
	pass 
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_settings_pressed() -> void:
	var settings = SETTINGS_SCENE.instantiate()
	get_tree().root.add_child(settings)
	
func _on_compendium_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
