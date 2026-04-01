extends Node2D


signal victory();

@onready var collisionBoxes = [$Body/BenagradsBase/EnnemyCollision_Base, $Body/BenagradsLoop/EnnemyCollision_Loop, $Body/BenagradsTop/EnnemyCollision_Top];

@onready var stats = Bestiary.monster(Bestiary.BENAGRADS);
@onready var last_rid : RID;
@onready var anim = $MonsterAnimationPlayer
@onready var hp_display = $RemainingMonsterHP
@onready var anim_player = $RemainingMonsterHP/HPAnimationPlayer;

@onready var mat := $Body.material as ShaderMaterial
@onready var boss_hp = $"../../Rigara".hp


func monster_death() -> void :
	boss_hp -= 50; #print("ouch");
	if boss_hp <= 0:
		victory.emit();
	mat.set_shader_parameter("active", false);
	for c in collisionBoxes:
		c.monitoring = false;
		c.monitorable = false;
	$RespawnTimer.start();
	hide();

func update_monster() -> void :
	stats.apply_damages();
	GLB_counter.increase_combo(stats.get_combo());
	if stats.get_health() == 0: monster_death();

func _on_character_body_2d_area_shape_entered(area_rid, area, _area_shape_index, _local_shape_index):
	if area_rid != last_rid && "LoopCollision" in area.name:
		last_rid = area_rid;
		
		stats.increment_combo();
		mat.set_shader_parameter("active", true);
		$HitTimer.start();
		
		hp_display.text = str(max(stats.health_calc(stats.calc_damages()), 0));
		hp_display.show();
		if anim_player.is_playing():
			anim_player.stop();
		anim_player.play(&"pop_in");


func _on_hp_animation_player_animation_finished(_anim_name): hp_display.hide();



func _on_hit_timer_timeout(): mat.set_shader_parameter("active", false);


func _on_monster_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		get_parent().ennemy_is_attacking(stats.get_strength());


func spawn_benagrads():
	show();
	stats = Bestiary.monster(Bestiary.BENAGRADS);
	for c in collisionBoxes:
		c.monitoring = true;
		c.monitorable = true;

func _on_respawn_timer_timeout(): spawn_benagrads();
