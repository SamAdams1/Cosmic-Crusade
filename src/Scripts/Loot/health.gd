extends Area2D

export var healthDropped = 5
export var speed = -5

onready var player = get_tree().current_scene.get_node('Player')

var target = null

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var sound = $collectedSound


func _physics_process(delta):
	global_position = global_position.move_toward(player.global_position, speed)
	speed += 10 * delta

func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return healthDropped

func _on_collectedSound_finished():
	queue_free()
