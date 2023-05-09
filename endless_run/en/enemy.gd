extends KinematicBody2D


var speed = 10
var move_dir = true
var velocity = Vector2.ZERO

func _process(delta):
	velocity = Vector2.ZERO
	
	if move_dir:
		# move right
		velocity.x += 100
		pass
	elif !move_dir:
		# move left
		velocity.x -= 100
		pass
		
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	body = str(body).split(":")[0]
	
	if "turn_l" in body:
		$EnemyL.show()
		$Enemy.hide()
		move_dir = false
	elif "turn_r" in body:
		move_dir = true
		$EnemyL.hide()
		$Enemy.show()
	elif "player" in body:
		queue_free()
