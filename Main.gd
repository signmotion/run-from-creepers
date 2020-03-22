extends Node


export (PackedScene) var Mob
var score = 0


func _ready():
    randomize()


func _on_Player_hit():
    game_over()


func new_game():
    $HUD.update_score(score)
    $HUD.show_message("Get Ready")
    score = 0
    $Player.start($StartPosition.position)
    $StartTimer.start()
    $Music.play()


func game_over():
    $HUD.show_game_over()
    $ScoreTimer.stop()
    $MobTimer.stop()
    $Music.stop()
    $DeathSound.play()


func _on_StartTimer_timeout():
    $MobTimer.start()
    $ScoreTimer.start()


func _on_ScoreTimer_timeout():
    score += 1
    $HUD.update_score(score)


func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.offset = randi()
    # Create a Mob instance and add it to the scene.
    var mob = Mob.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction += rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Set the velocity (speed & direction).
    mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
    mob.linear_velocity = mob.linear_velocity.rotated(direction)
    
    $HUD.connect("start_game", mob, "_on_start_game")


func _on_HUD_start_game():
    new_game()
