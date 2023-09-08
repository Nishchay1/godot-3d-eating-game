extends KinematicBody

signal idle
signal moving

signal power_up

signal level_up

signal death

onready var slime = $Mesh/Slime
onready var mesh = $Mesh
onready var camera_root = $CameraRoot

onready var mobile_controls = $MobileControls

var forwards_backwards:float = 0.0
var left_right:float = 0.0

export var speed = 14

export var jump_impulse = 30

export var fall_acceleration = 75

var velocity = Vector3.ZERO

var orientation = Transform()

export(int) var power

export(int) var level

export(int) var level_threshold

export(int) var power_up_threshold = 5

export(int) var knockback_amount = 50

onready var progress_bar = $Control/ColorRect/VBoxContainer/ProgressBar
onready var hurt_area = $HurtArea

func _ready():
	mobile_controls.visible=true

func _physics_process(delta):
	var direction = Vector3.ZERO
#	direction.x=forwards_backwards
#	direction.z=left_right
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	var cam_z = - camera_root.global_transform.basis.z
	var cam_x = camera_root.global_transform.basis.x
	cam_z.y = 0
	cam_z = cam_z.normalized()
	cam_x.y = 0
	cam_x = cam_x.normalized()
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		rotate_character((camera_root.transform.basis.get_rotation_quat()*-direction), delta)
		emit_signal("moving")
	else:
		emit_signal("idle")
	
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y += jump_impulse
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(camera_root.transform.basis*velocity, Vector3.UP)

func _on_MobileControls_use_move_vector(move_vector):
	forwards_backwards=move_vector.x
	left_right=move_vector.y

func rotate_character(direction, delta):
	var original_scale: Vector3 = mesh.get_scale()
	var q_from = Quat(orientation.basis)
	var q_to = Quat(Transform().looking_at(direction,Vector3.UP).basis)
	#Interpolate current rotation with desired one
	orientation.basis = Basis(q_from.slerp(q_to, delta * 10))
	orientation = orientation.orthonormalized() # orthonormalize orientation
	mesh.global_transform.basis = orientation.basis
	mesh.scale = original_scale

func increment_power(amount:int):
	power+=amount
	progress_bar.value+=20
	emit_signal("power_up",amount)
	if power>=power_up_threshold:
		level+=1
		grow()
		power=0
		progress_bar.value=0
		emit_signal("level_up", level)

func kill(t):
	hurt_area.disable_hurt_collisions()
	mobile_controls.visible=false
	emit_signal("death", t)

func grow():
	scale+=Vector3(1,1,1)

func _on_EaterArea_area_entered(area):
	if area.is_in_group("eat"):
		increment_power(area.get_power())
		area.destroy()

func _on_HurtArea_damaged():
	kill("YOU GOT EATEN")

func _on_InvincibilityTimer_timeout():
	hurt_area.enable_hurt_collisions()


func _on_Game_paused():
	mobile_controls.visible=false


func _on_Game_resumed():
	mobile_controls.visible=true


func _on_Timer_timeout():
	kill("TIME RAN OUT")
