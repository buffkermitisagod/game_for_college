extends Node2D


func save_diss(diff):
	var file = File.new()
	file.open("res://save_data/diff.txt", File.WRITE)
	file.store_string((str(diff)))
	file.close()


func _on_easy_pressed():
	save_diss(0)
	get_tree().change_scene("res://main/main_scene.tscn")

func _on_mid_pressed():
	save_diss(1)
	get_tree().change_scene("res://main/main_scene.tscn")

func _on_hard_pressed():
	save_diss(2)
	get_tree().change_scene("res://main/main_scene.tscn")
