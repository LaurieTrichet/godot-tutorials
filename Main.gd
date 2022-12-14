extends Node

export (PackedScene) var mob_scene
var score


func _ready():
	$HUD.update_score(0)
	$HUD.toggle_score_visibility(0)
	randomize()
	
func start_game():
	$BackgroundMusic.play()
	score = 0
	$HUD.toggle_score_visibility(1)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	
func _on_Player_hit():
	game_over()

func game_over():
	$BackgroundMusic.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()


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
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()


func _on_CanvasLayer_start_game():
	$HUD.update_score(0)
	$HUD.show_message("Get Ready")
	start_game()
