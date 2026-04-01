extends Resource

class_name GLB_counter

static var total = {
	"kill" : 0,
	"combo" : 0,
	"loop" : -1
};
static var temporary_total = {
	"kill" : 0,
	"combo" : 0,
	"loop" : -1
};

static func get_kill() -> int : return total["kill"];
static func get_combo() -> int : return total["combo"];
static func get_loop() -> int : return total["loop"];

static func get_temp_kill() -> int : return temporary_total["kill"];
static func get_temp_combo() -> int : return temporary_total["combo"];
static func get_temp_loop() -> int : return temporary_total["loop"];


static func increment_kill():
	temporary_total.kill += 1;
	total.kill += 1;

static func increase_combo(n : int):
	temporary_total.combo += n;
	total.combo += n;

static func increment_loop():
	temporary_total.loop += 1;
	total.loop += 1;

static func reset_all_temp():
	temporary_total = {
		"kill" : 0,
		"combo" : 0,
		"loop" : -1
	};
