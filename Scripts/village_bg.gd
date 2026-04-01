extends Node2D


func _on_ennemy_container_update_bg(condition, completion):
	if completion >= condition:
		$Vbg100.show()
	elif completion >= condition*0.75:
		$Vbg75.show()
	elif completion >= condition*0.50:
		$Vbg50.show()
	elif completion >= condition*0.25:
		$Vbg25.show()
