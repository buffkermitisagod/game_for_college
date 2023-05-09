extends Node2D




func _on_Button_pressed():
	get_tree().change_scene("res://main/main_scene.tscn")

func _on_Button2_pressed():
	get_tree().change_scene("res://titles/title.tscn")
