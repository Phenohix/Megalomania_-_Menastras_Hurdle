extends Node2D

static var BASE_SPEED := 70;
var movable : bool = true;
static var monster_dict = {"Ran": Bestiary.RANY, "Gad": Bestiary.GADROM};

@onready var stats = Bestiary.monster(monster_dict[name.substr(0, 3)]);
@onready var last_rid : RID;
@onready var anim = $MonsterAnimationPlayer
@onready var hp_display = $RemainingMonsterHP
@onready var anim_player = $RemainingMonsterHP/HPAnimationPlayer;

@onready var mat := $Body.material as ShaderMaterial


func _physics_process(delta):
	if movable:
		var direction_vector := position.direction_to($"../../Player_window".position);
		var speed = BASE_SPEED * stats.get_speed() * delta;
		position.x += speed * direction_vector.x;
		position.y += speed * direction_vector.y;
		if (direction_vector.x > 0): $Bones.scale.x = -1;
		else: $Bones.scale.x = 1;


func monster_death() -> void :
	get_parent().monster_eliminated();
	mat.set_shader_parameter("active", false);
	queue_free();

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
		
		#print(stats.get_combo(), " hits combo! ", stats.calc_damages(), " damages!");
		hp_display.text = str(max(stats.health_calc(stats.calc_damages()), 0));
		hp_display.show();
		if anim_player.is_playing():
			anim_player.stop();
		anim_player.play(&"pop_in");
	elif "WindowHitBox" in area.name:
		monster_death();
	elif "WindowHurtBox" in area.name:
		movable = false;
		anim.play("attack");


func _on_animation_player_animation_finished(_anim_name): hp_display.hide();


func _on_hit_timer_timeout(): mat.set_shader_parameter("active", false);


func _on_monster_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		get_parent().ennemy_is_attacking(stats.get_strength());
		anim.play("attack");
