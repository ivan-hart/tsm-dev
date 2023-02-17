extends "res://character3d.gd"

onready var pivot = $Pivot

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("key_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("key_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("key_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("key_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _physics_process(delta):
	velocity.y += -get_gravity() * delta
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	move_and_slide(velocity, direction)
