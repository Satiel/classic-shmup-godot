extends Area2D

@onready var screensize = get_viewport_rect().size
@export var speed = 150
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	$GunCooldown.wait_time = cooldown
	
func shoot():
	# shooting is currently on cooldown, do nothing
	if not can_shoot:
		return
		
	# shooting is NOT on cooldown, turn off shooting button and start the timer
	can_shoot = false
	$GunCooldown.start()
	
	# create the bullet object
	var b = bullet_scene.instantiate()
	
	# add the bullet to the current root tree
	get_tree().root.add_child(b)
	
	# assign the bullet's start position (ship, plus 8 pixels up)
	b.start(position + Vector2(0, -8))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check the pressed state of the given inputs (project settings > input map)
	var input = Input.get_vector("left", "right", "up", "down")
	
	# match animation to direction
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "Right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "Left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "Forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	if Input.is_action_pressed("shoot"):
		shoot()
		



func _on_gun_cooldown_timeout():
	can_shoot = true
