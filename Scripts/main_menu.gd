extends Node2D


func _on_play_pressed(): get_tree().change_scene_to_file("res://Scenes/main_game_window.tscn");


func _on_quit_pressed(): get_tree().quit();

func _on_close_button_pressed(): get_tree().quit();


func _on_glossary_pressed():
	pass # get_tree().change_scene_to_file("res://Scenes/glossary.tscn");


func _on_credits_button_pressed(): $Credits.show();

func _on_back_credits_pressed(): $Credits.hide();

func _ready():
	GLB_counter.reset_all_temp();
	print("Welcome, dear.");
