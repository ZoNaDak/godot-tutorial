extends Area2D

signal died
signal shield_changed

@export var speed = 150

@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true

@export var max_shield = 10
var shield = max_shield:
	set = set_shield

@onready var screen_size = get_viewport_rect().size

func _ready():
	start()

func start():
	position = Vector2(screen_size.x / 2, screen_size.y - 64)
	$GunCooldown.wait_time = cooldown
	shield = max_shield

func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), screen_size - Vector2(8, 8))
	
	if Input.is_action_pressed("shoot"):
		shoot()
	
func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0, -8))

func _on_gun_cooldown_timeout():
	can_shoot = true

func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		shield -= max_shield * 0.5
