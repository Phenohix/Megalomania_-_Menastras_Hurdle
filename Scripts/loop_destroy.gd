extends Line2D

@onready var ran = false;

func _ready():
	GLB_counter.increment_loop();
	$Timer.start();
	$LoopedLine.play();


func _on_timer_timeout():
	if ran || len(points) < 3:
		call_deferred("queue_free");
		return
	$LoopCollision/LoopCollisionPolygon2D.set_polygon(get_points());
	ran=true;
