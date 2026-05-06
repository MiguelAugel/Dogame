extends Area2D

var damage: float
var projectile_velocity: Vector2
var range: float
var effects: Array = []

var distance_traveled := 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += projectile_velocity * delta
	distance_traveled += projectile_velocity.length() * delta

	if distance_traveled > range:
		queue_free()

func _on_body_entered(body):
	print("collision")

	if body.has_method("take_damage"):
		body.take_damage(damage)

		for effect in effects:
			if effect.has_method("apply_on_hit"):
				effect.apply_on_hit(body, self)

	queue_free()
