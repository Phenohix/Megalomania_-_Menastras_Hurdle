extends Resource

class_name Stats

var max_health : int;
var health : int;
var strength : int;
var speed : int;


func _init(new_hp : int, new_spe : int, new_stre : int):
	max_health = new_hp; health = max_health;
	speed = new_spe;
	strength = new_stre;


func get_max_health(): return max_health;
func get_health(): return health;
func get_strength(): return strength;
func get_speed(): return speed;

func set_health(new_hp : int):
	if new_hp < 0:
		health = 0;
	elif new_hp > max_health:
		health = max_health
	else:
		health = new_hp;

func health_calc(hp_mod):
	return health - int(hp_mod);

func health_update(hp_mod):
	set_health(health_calc(hp_mod));
