extends EffectData

@export var burn_damage := 2
@export var duration := 3

func apply_on_hit(target, projectile):
	# A voir comment on implémente
	target.apply_burn(burn_damage, duration)
