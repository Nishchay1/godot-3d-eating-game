extends Area

signal damaged

func damage():
	emit_signal("damaged")

func disable_hurt_collisions():
	set_collision_mask_bit(2,false)

func enable_hurt_collisions():
	set_collision_mask_bit(2,true)
