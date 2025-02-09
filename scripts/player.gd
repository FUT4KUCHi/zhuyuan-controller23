extends CharacterBody3D


# Camera
@onready var camera_mount = $camera_mount
@export var sens_horizontal = 0.075
@export var sens_vertical = 0.100

# Animation
@onready var animation_player = $visuals/zhu_yuan/AnimationPlayer
@onready var visuals = $visuals

# Audio
@onready var running_sfx = $running_sfx
@onready var walking_sfx = $walking_sfx

# Player
@export var walk_speed = 1.525
@export var run_speed = 3.2575
var SPEED = 1.565
var running = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event): 
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))

func _process(delta):
	if Input.is_action_pressed("shift"):
		SPEED = run_speed
		running = true
	else:
		SPEED = walk_speed
		running = false

	# Exit
	if Input.is_action_just_pressed("esc-debug"):
		get_tree().quit()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animation_player.speed_scale = 1
		if running:
			if animation_player.current_animation != "run":
				animation_player.play("run")
				walking_sfx.stop()
				running_sfx.play()
		else:
			if animation_player.current_animation != "walk":
				animation_player.play("walk") 
				running_sfx.stop()
				walking_sfx.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		visuals.look_at(position + direction)
	else:
		if animation_player.current_animation != "idle":
			animation_player.speed_scale = 2.5
			animation_player.play("idle")
			walking_sfx.stop()
			running_sfx.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
