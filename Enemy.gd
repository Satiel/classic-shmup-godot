extends Area2D

signal died

var start_pos = Vector2.ZERO
var speed = 0
var bullet_scene = preload("res://Enemy_Bullet.tscn")

@onready var screensize = get_viewport_rect().size

func start(pos):
	# set the enemy speed
	speed = 0
	
	# set the enemy starting position
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	
	# wait until a random a mount of seconds before continuing movement
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	
	# create the tween, which uses the 'trans_back' animation to go from the starting position to the top portion
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	
	# wait until tween is finished
	await tween.finished
	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()
	
	


func _on_move_timer_timeout():
	speed = randf_range(75, 100)


func _on_shoot_timer_timeout():
	var b =  bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()
	
func _process(delta):
	position.y += speed * delta
	
	# once the enemy leaves the map, start them back at the top
	if position.y > screensize.y + 32:
		start(start_pos)

func explode():
	speed = 0
	$AnimationPlayer.play("Explode")
	set_deferred("monitoring", false)
	died.emit(5)
	await $AnimationPlayer.animation_finished
	queue_free()

