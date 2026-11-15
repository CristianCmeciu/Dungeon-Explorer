extends Node2D

@onready var bg_sound: AudioStreamPlayer = $bg_sound
@onready var chest_sfx: AudioStreamPlayer = $ChestSFX
@onready var armor_equip: AudioStreamPlayer = $ArmorEquip
@onready var weapon_equip: AudioStreamPlayer = $WeaponEquip
@onready var gold_take: AudioStreamPlayer = $GoldTake

func play_sound(key):
	var sound = get(key)
	if sound is AudioStreamPlayer:
		sound.play()
