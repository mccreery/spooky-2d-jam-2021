extends Character

var max_health = 4
var health = 1 setget set_health

func play_sfx(stream):
    if !$AudioStreamPlayer2D.is_playing():
        $AudioStreamPlayer2D.stream = stream
        $AudioStreamPlayer2D.play()

func set_health(value):
    health = clamp(value, 0, max_health)
    if value <= 0:
        die()

var game_over_sound = preload("res://sfx/game_over.wav")
var eat_sound = preload("res://sfx/chomp.wav")

func get_input_direction():
    return Vector2(
        Input.get_action_strength("right") - Input.get_action_strength("left"),
        Input.get_action_strength("down") - Input.get_action_strength("up")
    ).clamped(1)

func _process(_delta):
    walk_direction = get_input_direction()

    if Input.is_action_just_pressed("interact") and close_enemy != null:
        close_enemy.queue_free()
        play_sfx(eat_sound)
        self.health += 1

func die():
    set_process(false)
    play_sfx(game_over_sound)

func _on_AudioStreamPlayer2D_finished():
    if $AudioStreamPlayer2D.stream == game_over_sound:
        get_tree().call_deferred("change_scene", "res://scenes/menu.tscn")

var close_enemy = null
func _on_range_trigger_body_entered(body):
    if body is Enemy && close_enemy == null:
        close_enemy = body

func _on_range_trigger_body_exited(body):
    if body == close_enemy:
        close_enemy = null
