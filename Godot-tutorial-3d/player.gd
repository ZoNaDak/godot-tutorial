extends CharacterBody3D

@export var speed = 14
@export var fall_accelaration = 75

var target_veclocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if(Input.is_action_pressed("move_right")):
		direction.x += 1
	if(Input.is_action_pressed("move_left")):
		direction.x -= 1
	if(Input.is_action_pressed("move_forward")):
		direction.z -= 1
	if(Input.is_action_pressed("move_back")):
		direction.z += 1
	
	if(direction != Vector3.ZERO):
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)

	target_veclocity.x = direction.x * speed
	target_veclocity.z = direction.z * speed
	
	if not is_on_floor():
		target_veclocity.y = target_veclocity.y - (fall_accelaration * delta)
		
	velocity = target_veclocity
	move_and_slide()
