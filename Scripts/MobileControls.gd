extends CanvasLayer

signal use_move_vector
signal use_look_vector


var move_vector = Vector2(0, 0)

var joystick_active:bool = false

var look_active:bool = false
var look_vector:Vector2 = Vector2(0,0)

onready var joystick_base = $JoyStickArea/JoyStick
onready var joystick_stick = $JoyStickArea/Sprite

onready var pop_up_area = $PopUpArea
onready var numbers_pop_up:PackedScene = preload("res://Scenes/NumbersPopUp.tscn")

func _process(delta):
	look_vector=Vector2.ZERO

func _physics_process(_delta):
	if joystick_active:
		emit_signal("use_move_vector", move_vector)
	else:
		emit_signal("use_move_vector",Vector2(0,0))
	emit_signal("use_look_vector",look_vector)


func calculate_move_vector(event_position):
	var texture_center = joystick_base.global_position + Vector2(80,80)
	return (event_position - texture_center).normalized()

func clamp_vector(vector, clamp_origin, clamp_length):
	var offset = vector - clamp_origin
	return clamp_origin + offset.limit_length(clamp_length)


func _on_LookArea_input_event(viewport, event, shape_idx):
	if event is InputEventScreenDrag:
		look_vector = event.relative


func _on_Control_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if joystick_base.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			joystick_stick.global_position = clamp_vector(event.position, joystick_base.global_position+Vector2(80,80), 80)
	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false
			joystick_stick.global_position = joystick_base.global_position+Vector2(80,80)



func _on_Player_power_up(amount):
	var number = numbers_pop_up.instance()
	number.set_text("+"+str(amount))
	pop_up_area.add_child(number)
	number.pop_up()
