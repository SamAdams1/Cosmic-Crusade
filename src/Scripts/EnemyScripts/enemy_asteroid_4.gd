extends "res://Scripts/EnemyScripts/enemy_core.gd"

var is_in_void = false
onready var retreatTimer = $retreatArea/retreatTimer
var stun = false

func _ready():
	movementSpeed = Global.playerMovementSpeed / 2

func _process(delta):
	if stun == false:
		basic_movement_towards_player(delta)

	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack") and knockbackUnlocked:
		velocity = -velocity * knockback
		stun = true
		$stun_timer.start()


func _on_retreatArea_body_entered(body):
	if body.is_in_group('player'):
		retreatTimer.stop()
		movementSpeed = Global.playerMovementSpeed
		playerPush = -1

func _on_retreatArea_body_exited(body):
	if body.is_in_group('player'):
		movementSpeed = 0
		retreatTimer.start()

func _on_retreatTimer_timeout():
	movementSpeed = Global.playerMovementSpeed / 2
	playerPush = 1
