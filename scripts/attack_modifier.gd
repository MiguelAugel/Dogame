extends Resource
class_name AttackModifier

@export var damage_mult := 1.0
@export var damage_add := 0.0
@export var fire_rate_mult := 1.0
@export var fire_rate_add := 0.0
@export var projectile_speed_mult := 1.0
@export var projectile_speed_add := 0.0
@export var range_mult := 1.0
@export var range_add := 0.0
@export var size_mult := 1.0
@export var size_add := 0.0

# Effets ajoutés
@export var added_effects: Array[EffectData] = []

func apply(data: AttackData) -> AttackData:
	var new_data = data.duplicate()

	# Stats
	new_data.damage += damage_add
	new_data.damage *= damage_mult
	new_data.fire_rate += fire_rate_add
	new_data.fire_rate *= fire_rate_mult
	new_data.projectile_speed += projectile_speed_add
	new_data.projectile_speed *= projectile_speed_mult
	new_data.range += range_add
	new_data.range *= range_mult
	new_data.projectile_size += size_add
	new_data.projectile_size *= size_mult

	# Effets
	for effect in added_effects:
		new_data.effects.append(effect)

	return new_data
