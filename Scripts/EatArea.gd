extends Area

export(int) var power

onready var eat_particles:PackedScene = preload("res://Scenes/Particles/EatParticle.tscn")

onready var static_body = $StaticBody

func get_power():
	return power

func destroy():
	eat_effect()
	get_parent().queue_free()

func eat_effect():
	var p = eat_particles.instance()
	p.transform=global_transform
	get_tree().current_scene.add_child(p)

func set_edible(val):
	set_collision_mask_bit(3,val)

func set_walkable(val):
	static_body.set_collision_layer_bit(1,val)
