extends Node2D



func _ready():
	var file = File.new()
	file.open("res://save_data/score.txt", File.READ)
	var content = file.get_as_text()
	file.close()
	$Label.text = "High Score: "+content+"\nTry And Beat It!"
	
func _on_Button_pressed():
	# load main game
	get_tree().change_scene("res://titles/diff_sel.tscn")


func _on_Button2_pressed():
	# load toutorial
	get_tree().change_scene("res://toutorial/toutorial_scene.tscn")
