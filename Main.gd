extends Node

export (PackedScene) var mob_scene
var score


func _ready():
	randomize()
	start_game()
	

func _on_Player_hit():
	game_over()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()


func start_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_MobTimer_timeout():
	spawn_mob()	


func spawn_mob():
	var mob = mob_scene.instance()
	
	var spawn_position = $MobPath/MobSpawnLocation
	spawn_position.offset = randi()
	mob.position = spawn_position.position

	var direction = spawn_position.rotation + PI/2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var speed = rand_range(150.0, 250.0)
	var velocity = Vector2(speed, 0.0)
	var rotated_velocity = velocity.rotated(direction)
	print_debug(rotated_velocity)
	mob.linear_velocity = rotated_velocity
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1


func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()
