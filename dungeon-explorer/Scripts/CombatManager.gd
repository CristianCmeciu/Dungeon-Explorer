class_name CombatManager
extends Node

signal fightWon
signal updateHP

var potion_blocked: bool = false
var fight_begin: bool = false
var player: Player
var enemy: Enemy
var enemyFirst: bool
var text: Label
var hpLeft: ColorRect

func startCombat(p: Player, e: Entity,label:Label,hpRect: ColorRect, enemyAttacksFirst: bool = false):
	player = p
	enemy = e
	enemyFirst = enemyAttacksFirst
	text = label
	hpLeft = hpRect
	fight_begin = true
	if enemyAttacksFirst:
		enemyTurn()

func _process(_delta):
	if !fight_begin: 
		return
	if Input.is_action_just_pressed("attack"):
		playerAttack()
	elif Input.is_action_just_pressed("defend"):
		playerDefend()

func playerDefend():
	text.text = "You defend yourself! +1 DEF for 3 turns!"
	AudioManager.play_sound(AudioManager.SoundType.PLAYER_DEFEND)
	player.defend()
	enemyTurn()

func playerAttack():
	enemy.takeDamage(player.attack())
	AudioManager.play_sound(AudioManager.SoundType.ATTACK_PLAYER)
	hpLeft.size.x = (hpLeft.custom_maximum_size.x / enemy.maxHp) * enemy.hp
	print("Enemy got hit ",player.attack(),". Remaining hp: ",enemy.hp)
	text.text = "You hit the enemy!"
	if enemy.hp <= 0:
		endCombat()
		return
	if(player.weapon != null):
		if Equipments.Minion.STUN in player.owned_minions:
			enemy.applyStun(player.weapon.stunTime + 1)
		else:
			enemy.applyStun(player.weapon.stunTime)
		if(player.weapon.effect != null):
			var effect = player.weapon.effect
			enemy.applyEffect(effect)
	enemyTurn()
	
func enemyTurn():
	
	if enemy is Witch:
		var effect = enemy.throwPotion()
		if Equipments.Minion.POTION in player.owned_minions and !potion_blocked:
			AudioManager.play_sound(AudioManager.SoundType.MINION_PROTECT)
			text.text += "\n" + enemy.name + " splashed you with " + effect.name + ", but the minion protected you!"
			potion_blocked = true
		else:
			AudioManager.play_sound(AudioManager.SoundType.POTION_THROW)
			text.text += "\n" + enemy.name + " splashed you with " + effect.name + "!"
			player.applyEffect(effect)
	else:
		match enemy:
			Mimic:
				AudioManager.play_sound(AudioManager.SoundType.MIMIC_ATTACK)
			Skeleton:
				AudioManager.play_sound(AudioManager.SoundType.SKELETON_ATTACK)
		text.text += "\n" + enemy.name + " hit you!"
		player.takeDamage(enemy.attack())
	updateHP.emit()
	if player.hp <= 0:
		endCombat()
		return
	if !enemyFirst:
		player.onTurnEnd()
	else:
		enemyFirst = false
	enemy.onTurnEnd()
	if player.hp <= 0 or enemy.hp <= 0:
		endCombat()
		return
		

func endCombat():
	potion_blocked = false
	if player.hp > 0:
		print("Player won")
		player.addGold(enemy.goldValue)
		match enemy:
			Mimic:
				AudioManager.play_sound(AudioManager.SoundType.MIMIC_DEATH)
			Witch:
				AudioManager.play_sound(AudioManager.SoundType.WITCH_DEATH)
			Skeleton:
				AudioManager.play_sound(AudioManager.SoundType.SKELETON_DEATH)
		fightWon.emit()
	else:
		print("Player not won")
