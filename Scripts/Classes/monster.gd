class_name Monster

extends Stats

static var line_is_active = false;
var combo : int = 0;

func _init(new_hp : int, new_spe : int, new_def : int):
	super(new_hp, new_spe, new_def);

func get_combo(): return combo;
func increment_combo():
	if line_is_active: combo+=1;
	else: combo = 0;

func reset_combo(): combo = 0;

@warning_ignore("integer_division")
func calc_damages(): return (combo+1)*combo/2;

func apply_damages(): if !line_is_active: health_update(calc_damages());
