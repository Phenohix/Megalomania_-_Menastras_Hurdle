extends Resource

class_name Bestiary

enum {
	RANY,
	GADROM,
	REBOM,
	BENAGRADS,
	RIGARA
}


# Monster.new(health, speed, strength)
static func monster(id: int) -> Monster :
	match id:
		RANY:
			return Monster.new(30, 2, 2);
		GADROM:
			return Monster.new(15, 6, 1);
		REBOM:
			return Monster.new(90, 1, 4);
		BENAGRADS:
			return Monster.new(46, 0, 4);
		RIGARA:
			return Monster.new(300, 0, 3);
		_:
			return Monster.new(2**63-1, 2**63-1, 2**63-1);
