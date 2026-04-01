extends Node2D

signal ennemy_attacked(dmg);
signal boss_phase();
signal update_bg(condition, completion);

#const ENEMY_SCENES = [ENEMY_SCENE_1, ENEMY_SCENE_2, ..., ENEMY_SCENE_n]
const ENEMY_SCENES = [preload("res://Scenes/Ennemies/rany.tscn"),
						preload("res://Scenes/Ennemies/gadrom.tscn")]
const WEIGHTS : Array = [1, 2];

var baseRandomBag : Array = [0, 0, 1];
var randomBag : Array = [];

@onready var cam := $"../Camera2D"
@onready var label := $"../WinningLabel"
@onready var spawn_timer := $"../MobSpawnTimer"

@onready var screen_x = get_viewport_rect().size.x / cam.zoom.x /2
@onready var screen_y = get_viewport_rect().size.y / cam.zoom.y /2
@onready var origin_x = -screen_x
@onready var origin_y = -screen_y

const monster_cap : int = 13;
const clear_condition : int = 32;
var total_spawned : int = 0;
var monsters_spawned : int = 0;

enum { NORTH, WEST, SOUTH, EAST };


func _on_line_2d_line_is_broken():
	for c in get_children():
		c.stats.reset_combo();


func _on_line_2d_line_is_done():
	for c in get_children():
		c.update_monster();
		c.stats.reset_combo()


func ennemy_is_attacking(dmg): ennemy_attacked.emit(dmg);

func _on_rigara_rigara_roared(): ennemy_attacked.emit($"../Player_window".player_stats.get_max_health()*0.1);


func monster_eliminated() -> void :
	GLB_counter.increment_kill();
	label.set_text(str(GLB_counter.get_temp_kill()) + " / " + str(clear_condition));
	monsters_spawned -= 1;
	var temp_kills = GLB_counter.get_temp_kill()
	update_bg.emit(clear_condition, temp_kills);
	if temp_kills >= clear_condition:
		boss_phase.emit();


func cardinality_spawn(cardinality = null) -> Vector2:
	match cardinality:
		NORTH: return Vector2(randf_range(origin_x, screen_x), origin_y+100);
		WEST: return Vector2(origin_x-100, randf_range(origin_y, screen_y));
		SOUTH: return Vector2(randf_range(origin_x, screen_x), screen_y-100);
		EAST: return Vector2(screen_x-100, randf_range(origin_y, screen_y));
		_: return cardinality_spawn([NORTH, WEST, EAST, SOUTH].pick_random());

func _on_mob_spawn_timer_timeout():
	if total_spawned < clear_condition:
		if monsters_spawned < monster_cap:
			if randomBag.is_empty():
				randomBag = baseRandomBag.duplicate();
				randomBag.shuffle();
			var enemy = ENEMY_SCENES[randomBag[-1]].instantiate();
			randomBag.pop_back();
			add_child(enemy, true);
			monsters_spawned += 1; total_spawned += 1;
			enemy.global_position = cardinality_spawn();
		var magic = 6.5 * (1 - (float(total_spawned)/float(clear_condition))*0.25);
		if (magic < 0.9): magic = 0.9;
		spawn_timer.start(magic);

func spawn_boss_mob():
	var enemy = ENEMY_SCENES[1].instantiate();
	add_child(enemy, true);
	monsters_spawned += 1; total_spawned += 1;
	enemy.global_position = cardinality_spawn();

func _ready():
	label.set_text("0 / %d" % clear_condition);
	var children = [];
	for c in get_children():
		children.append(c);
	for c in children:
		c.queue_free();


func _on_benagrads_victory(): get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");
