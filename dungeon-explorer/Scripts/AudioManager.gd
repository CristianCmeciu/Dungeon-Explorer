extends Node2D

@onready var bg_sound: AudioStreamPlayer = $bg_sound
@onready var chest_sfx: AudioStreamPlayer = $ChestSFX
@onready var armor_equip: AudioStreamPlayer = $ArmorEquip
@onready var weapon_equip: AudioStreamPlayer = $WeaponEquip
@onready var gold_take: AudioStreamPlayer = $GoldTake
@onready var mob_death: AudioStreamPlayer = $MobDeath
@onready var trap_death: AudioStreamPlayer = $TrapDeath
@onready var fight_death: AudioStreamPlayer = $FightDeath
@onready var attack_p1: AudioStreamPlayer = $AttackPlayer1
@onready var attack_p2: AudioStreamPlayer = $AttackPlayer2
@export var dungeon_collapse: AudioStreamPlayer
@export var defend: AudioStreamPlayer
@export var potion_throw : AudioStreamPlayer
@export var minion_protect: AudioStreamPlayer
@export var mimic_attack: AudioStreamPlayer
@export var usa_fache: AudioStreamPlayer
@export var skeleton_attack: AudioStreamPlayer
@export var witch_death: AudioStreamPlayer
@export var minion_cry: AudioStreamPlayer
@export var skeleton_death: AudioStreamPlayer
@export var minion_happy: AudioStreamPlayer
@export var next_room: AudioStreamPlayer

enum SoundType {BACKGROUND, OPEN_CHEST, EQUIP_ARMOR, EQUIP_WEAPON, TAKE_GOLD, MIMIC_DEATH,
				TRAP_DEATH, FIGHT_DEATH, ATTACK_PLAYER, DUNGEON_COLLAPSE, PLAYER_DEFEND, 
				POTION_THROW, MINION_PROTECT, MIMIC_ATTACK, USA_FACHE, SKELETON_ATTACK,
				WITCH_DEATH, MINION_CRY, SKELETON_DEATH, MINION_HAPPY, NEXT_ROOM
				}
				
var sounds = {SoundType.BACKGROUND : ["bg_sound"],
				SoundType.OPEN_CHEST : ["chest_sfx"],
				SoundType.EQUIP_ARMOR : ["armor_equip"],
				SoundType.EQUIP_WEAPON : ["weapon_equip"],
				SoundType.TAKE_GOLD : ["gold_take"],
				SoundType.MIMIC_DEATH : ["mob_death"],
				SoundType.TRAP_DEATH : ["trap_death"],
				SoundType.FIGHT_DEATH : ["fight_death"],
				SoundType.ATTACK_PLAYER : ["attack_p1", "attack_p2"],
				SoundType.DUNGEON_COLLAPSE : ["dungeon_collapse"],
				SoundType.PLAYER_DEFEND : ["defend"],
				SoundType.POTION_THROW : ["potion_throw"],
				SoundType.MINION_PROTECT : ["minion_protect"],
				SoundType.MIMIC_ATTACK : ["mimic_attack"],
				SoundType.USA_FACHE: ["usa_fache"],
				SoundType.SKELETON_ATTACK: ["skeleton_attack"],
				SoundType.WITCH_DEATH: ["witch_death"],
				SoundType.MINION_CRY: ["minion_cry"],
				SoundType.SKELETON_DEATH: ["skeleton_death"],
				SoundType.MINION_HAPPY: ["minion_happy"],
				SoundType.NEXT_ROOM: ["next_room"]
				
				}


func play_sound(key: SoundType):
	var sound = get(sounds[key][randi() % sounds[key].size()])
	if sound is AudioStreamPlayer:
		sound.play()

func stop_sound(key: SoundType):
	var sound = get(sounds[key][randi() % sounds[key].size()])
	if sound is AudioStreamPlayer:
		sound.stop()
