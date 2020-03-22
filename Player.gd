extends Area2D


signal hit


export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var target = Vector2()


func _ready():
    screen_size = get_viewport_rect().size
    hide()


# Change the target whenever a touch event happens.
func _input(event):
    if event is InputEventScreenTouch and event.pressed:
        target = event.position


func _process(delta):
    # The player's movement vector.
    var velocity = Vector2()
    # Move towards the target and stop when close.
    if position.distance_to(target) > 10:
        velocity = (target - position).normalized() * speed
    else:
        velocity = Vector2()

    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    position += velocity * delta
    # We still need to clamp the player's position here because on devices that don't
    # match your game's aspect ratio, Godot will try to maintain it as much as possible
    # by creating black borders, if necessary.
    # Without clamp(), the player would be able to move under those borders.
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
    
    if velocity.x != 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = velocity.y < 0
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0
        $AnimatedSprite.flip_h = velocity.x > 0


func _on_Player_body_entered(body):
    hide()  # Player disappears after being hit.
    emit_signal("hit")
    $CollisionShape2D.set_deferred("disabled", true)
    

func start(pos):
    position = pos
    target = pos
    $CollisionShape2D.disabled = false
    show()
    
