extends KinematicBody2D

var damageNumbers = preload("res://Scenes/Enemies/DamageNumbers.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
var coin = preload("res://Scenes/Objects/coin.tscn")
var healthDrop = preload("res://Scenes/Objects/healthDropped.tscn")


onready var player = get_tree().current_scene.get_node('Player')
onready var playerCollision = $PlayerCollision
onready var bulletCollision = $BulletCollision/CollisionShape2D
onready var hurtBox = $HurtBox/CollisionShape2D
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite = $Sprite
onready var sound = $DeathExplosionSound
onready var lootBase = get_tree().current_scene.get_node('lootBase')
var notDead = true

onready var statUpgrade = get_tree().get_root().find_node('StatUpgrade', true, false)

var velocity = Vector2.ZERO
#enemy stats you can change in inspector
export var movementSpeed = 100
export var health = 2
export var experienceDroppedValue = 1
export var coinDroppedValue = 1
export var healthDroppedValue = 5
var knockback = Global.knockback
var knockbackUnlocked = Global.knockbackUnlocked

var playerPush = 1
var isBossDead = false


func _ready():
	statUpgrade.connect('setKnockBack', self, 'setEnemyKnockback')
	health += Global.enemyHealthAdded

func basic_movement_towards_player(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movementSpeed * playerPush
	move_and_slide(velocity)


func _on_HurtBox_hurt(damage):
	health -= damage
	if notDead:
		var text = damageNumbers.instance()
		text.amount = damage
		add_child(text)
		
		if health <= 0:
			if self.name == 'bossEnemy':
				isBossDead = true
				notDead = false
				disableEnemyOnDead()
			else:
				notDead = false
				disableEnemyOnDead()
			sprite.visible = false
			if !sound.playing:
				sound.play()
			Global.enemiesKilled += 1
			
			#explosion animation
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			
			createLoot()
	if self.name == 'bossEnemy':
		player.bossHealthBar.value -= damage

func disableEnemyOnDead():
	playerCollision.call_deferred("set", "disabled", true)
	bulletCollision.call_deferred("set", "disabled", true)
	hitBox.call_deferred("set", "disabled", true)
	hurtBox.call_deferred("set", "disabled", true)
	movementSpeed = 0


func createLoot():
	var spawnChance = round(rand_range(0, 10))
	
#	if int(spawnChance) == 0 and player.playerHealth < player.healthBar.max_value / 2:
#		var healing = healthDrop.instance()
#		healing.healthDropped = healthDroppedValue
#		healing.global_position = global_position
#		lootBase.call_deferred("add_child", healing)
		
	if spawnChance > 3:
		var newXPGem = xpGem.instance()
		newXPGem.experience = experienceDroppedValue
		newXPGem.global_position = global_position
		lootBase.call_deferred("add_child", newXPGem)
		
	elif spawnChance < 2:
		var newCoin = coin.instance()
		newCoin.coinValue = coinDroppedValue
		newCoin.global_position = global_position
		lootBase.call_deferred("add_child", newCoin)

func setEnemyKnockback():
	knockback = Global.knockback
	knockbackUnlocked = true
	Global.knockbackUnlocked = true



