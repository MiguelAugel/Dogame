extends CharacterBody2D

const SPEED = 100.0

# Vie
@export var max_health: float = 100.0
var health: float

func take_damage(amount: float):
	health -= amount
	health = max(health, 0)
	
	if health <= 0:
		die()

func heal(amount: float):
	health += amount
	health = min(health, max_health)

func die():
	queue_free()

# Attaque
@export var base_attack: AttackData
var modifiers: Array[AttackModifier] = []

var attack_cooldown := 0.0

func _ready():
	health = max_health

func _process(delta):
	handle_attack(delta)
	
func get_shoot_direction() -> Vector2:
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("shoot_down"):
		dir.y += 1
		return dir.normalized()
	if Input.is_action_pressed("shoot_up"):
		dir.y -= 1
		return dir.normalized()
	if Input.is_action_pressed("shoot_right"):
		dir.x += 1
		return dir.normalized()
	if Input.is_action_pressed("shoot_left"):
		dir.x -= 1
		return dir.normalized()
	
	return dir.normalized()

func handle_attack(delta):
	var dir = get_shoot_direction()
	
	if attack_cooldown > 0:
		attack_cooldown -= delta
		
	if attack_cooldown < 0:
		attack_cooldown = 0
	
	if dir == Vector2.ZERO:
		return
	
	var attack = get_final_attack()
	var delay = 1.0 / attack.fire_rate
	
	while attack_cooldown <= 0:
		shoot(attack, dir)
		attack_cooldown += delay

func get_final_attack() -> AttackData:
	var result = base_attack.duplicate()

	for mod in modifiers:
		result = mod.apply(result)
		if mod.has_method("modify_attack"):
			mod.modify_attack(result)

	return result

func shoot(attack: AttackData, dir: Vector2):
	if attack.projectile_scene == null:
		return
	
	var proj = attack.projectile_scene.instantiate()
	
	proj.global_position = global_position
	proj.projectile_velocity = dir * attack.projectile_speed
	proj.damage = attack.damage
	proj.range = attack.projectile_range
	proj.effects = attack.effects.duplicate()
	
	proj.scale *= attack.projectile_size
	
	for effect in proj.effects:
		if effect.has_method("modify_projectile"):
			effect.modify_projectile(proj)
	
	get_tree().current_scene.add_child(proj)

# Shmovement
func _physics_process(delta: float) -> void:
	var directionX := Input.get_axis("move_left", "move_right")
	var directionY := Input.get_axis("move_up", "move_down")
	var currentSpeed := (SPEED * 0.75) if (directionX && directionY) else SPEED

	if directionX:
		velocity.x = directionX * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed * 0.1)
		
	if directionY:
		velocity.y = directionY * currentSpeed
	else:
		velocity.y = move_toward(velocity.y, 0, currentSpeed * 0.1)

	move_and_slide()
