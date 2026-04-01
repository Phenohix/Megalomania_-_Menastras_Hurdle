extends Node2D


@onready var all_benagrads = [$BenagradsMarker1/Benagrads, $BenagradsMarker2/Benagrads];


func _on_line_2d_line_is_broken():
	for b in all_benagrads: b.stats.reset_combo();

func _on_line_2d_line_is_done():
	for b in all_benagrads:
		b.update_monster();
		b.stats.reset_combo();


func _on_ennemy_container_boss_phase():
	for b in all_benagrads: b.spawn_benagrads();


func _on_boss_ennemy_spawn_timer_timeout():
	$"../EnnemyContainer".spawn_boss_mob();
	
