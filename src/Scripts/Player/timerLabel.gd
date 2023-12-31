extends Label

var time = Global.timer

signal stopEnemySpawning

func _process(delta):
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		time -= delta

		var secs = fmod(time, 60)
		var mins = fmod(time, 60*60) / 60
		var timePassed = "%02d:%02d" % [mins,secs]
		text = timePassed
	if time <= 0:
		emit_signal("stopEnemySpawning")

