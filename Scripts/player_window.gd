extends Node2D

@onready var player_stats : Stats = Stats.new(100, 0, 0);
@onready var health_bars = [$HealthBar, $WindowRect/TitleBarRect];

@onready var mats := [health_bars[0].material as ShaderMaterial, health_bars[1].material as ShaderMaterial]


func _on_ennemy_attacked(dmg):
	player_stats.health_update(dmg);
	for mat in mats:
		mat.set_shader_parameter("health", float(player_stats.get_health())/float(player_stats.get_max_health()));
	if player_stats.get_health() <= 0:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");


func _on_ennemy_container_boss_phase():
	$WindowRect.queue_free();
	position.y = $"../BossFightWindowMarker".position.y
