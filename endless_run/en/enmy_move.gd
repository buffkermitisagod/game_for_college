extends PathFollow2D

var speed = 100

func _physics_process(delta):
	if get_unit_offset() == 1:
		queue_free()
	else:
		set_offset(get_offset() + speed * delta)


func _on_Area2D_body_entered(body):
	body = str(body).split(":")[0]
	
	if "turn_l" in body:
		$enemy/EnemyL.show()
		$enemy/Enemy.hide()
	elif "turn_r" in body:
		$enemy/EnemyL.hide()
		$enemy/Enemy.show()
