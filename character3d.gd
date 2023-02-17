extends KinematicBody

signal health_depleted()
signal oxygen_depleted()
signal energy_depleted()

var health : float = 0.0
var energy : float = 0.0
var oxygen : float = 0.0

var health_damage : float = 0.0
var oxygen_damage : float = 0.01
var energy_damage : float = 0.05

var mouse_sensitivity : float = 0.03
var max_speed : int = 30

func set_health_damage_oxygen():
	health_damage = 0.05

func set_health_damage_energy():
	if health_damage >= 0.05:
		return
	health_damage = 0.01

func reset_health_damage():
	if oxygen and energy:
		health_damage = 0

func set_energy(value):
	if energy - value <= 0:
		energy = 0
		emit_signal("energy_depleted")
	energy = value

func set_oxygen(value):
	if oxygen - value <= 0:
		oxygen = 0
		emit_signal("oxygen_depleted")
	oxygen = value

func set_health(value):
	if health - value <= 0:
		health = 0
		emit_signal("health_depleted")
	health = value

func decrease_stats_overtime(delta):
	set_health(health - health_damage * delta)
	set_oxygen(oxygen - oxygen_damage * delta)
	set_energy(energy - energy_damage * delta)

var velocity : Vector3 = Vector3()
var direction : Vector3 = Vector3()

var jump_force : float = 30.0

func set_velocity(vel):
	velocity = vel

func set_jump_force(amount):
	jump_force = amount

func get_gravity():
	return ProjectSettings.get_setting("physics/3d/default_gravity")

func set_gravity(amount):
	ProjectSettings.set_setting("physics/3d/default_gravity", amount)

func toggle_cursor():
	if Input.is_mouse_mode(Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready():
	# warning-ignore:return_value_discarded
	connect("energy_depleted", self, "set_health_damage_oxygen")
	# warning-ignore:return_value_discarded
	connect("energy_depleted", self, "set_health_damage_energy")
	# warning-ignore:return_value_discarded
	connect("reset_health_damage", self, "reset_health_damage")
