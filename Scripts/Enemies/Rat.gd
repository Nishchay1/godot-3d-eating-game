extends KinematicBody

onready var animation_player = $AnimationPlayer

var idle:bool = false

export(int) var speed = 14

var fall_acceleration = 75

var velocity:Vector3 = Vector3.ZERO

var direction:Vector3 = Vector3.ZERO

var orientation = Transform()


func _physics_process(delta):
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		rotate_character((-direction), delta)
	if idle:
		velocity = Vector3.ZERO
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

func change_direction():
	direction.x = [-1,0,1][randi() % 3]
	direction.z = [-1,0,1][randi() % 3]


func rotate_character(direction, delta):
	var q_from = Quat(orientation.basis)
	var q_to = Quat(Transform().looking_at(direction,Vector3.UP).basis)
	
	#Interpolate current rotation with desired one
	orientation.basis = Basis(q_from.slerp(q_to, delta * 10))
	
	orientation = orientation.orthonormalized() # orthonormalize orientation
	global_transform.basis = orientation.basis

func _on_Timer_timeout():
	idle = !idle
	if idle:
		animation_player.play("RESET")
	else:
		change_direction()
		if !animation_player.is_playing():
			animation_player.play("running")
