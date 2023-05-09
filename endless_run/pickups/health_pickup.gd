extends StaticBody2D

var pik = false

func _on_Area2D_body_entered(body):
	body = str(body).split(":")[0]
	print("body: ", body)
	if body == "player" and !pik:
		$Timer.start()
		pik = true


func _on_Timer_timeout():
	print("wow!")
	queue_free()
