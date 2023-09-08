extends Spatial

export(float, 0.0, 1.0) var sensitivity = 0.25
var _touch_position = Vector2(0.0, 0.0)

func _process(delta):
	_update_look()

func _update_look():
	_touch_position *= sensitivity
	var yaw = _touch_position.x
	rotate_y(deg2rad(-yaw))

func _on_MobileControls_use_look_vector(look_vector):
	_touch_position=look_vector
