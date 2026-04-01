extends Line2D


signal line_is_broken();
signal line_is_done();

@onready var line = $"."
@onready var start_dot = $StartDot
@onready var line_coll = $LineCollision/LineCollisionPolygon2D

@onready var sfx_break = $SFX/BreakingSoundEffect
@onready var sfx_active = $SFX/LineActive

@onready var last_mouse_pos := Vector2(-1, -1);
const segment_len = 200;
@onready var max_points = 50;



func orientation(p, q, r) -> float:
	# returns 0=collinear, >0=clockwise, <0=counterclockwise
	return (q[0]-p[0])*(r[1]-q[1]) - (q[1]-p[1])*(r[0]-q[0]);

func on_segment(p, q, r) -> bool:
	# checks if q lies between p and r (collinear case)
	return min(p[0], r[0]) <= q[0] and q[0] <= max(p[0], r[0]) and \
		   min(p[1], r[1]) <= q[1] and q[1] <= max(p[1], r[1]);

func segments_intersect(A, B, C, D) -> bool:
	var o1 : float = orientation(A, B, C);
	var o2 : float = orientation(A, B, D);
	var o3 : float = orientation(C, D, A);
	var o4 : float = orientation(C, D, B);
	# general case
	if o1*o2 < 0 and o3*o4 < 0: return true;
	# special cases (collinear)
	if (o1 == 0 and on_segment(A, C, B)) or \
	   (o2 == 0 and on_segment(A, D, B)) or \
	   (o3 == 0 and on_segment(C, A, D)) or \
	   (o4 == 0 and on_segment(C, B, D)): return true;
	
	return false


func _physics_process(_delta):
	line_coll.set_polygon(witchCraft(line.get_points()));
	
	var current_mouse_pos := get_local_mouse_position();
	if Input.is_action_pressed("left_mouse_button"):
		if !Monster.line_is_active:
			#sfx_active.pitch_scale(1.-float(randi()%4-1)/10.);
			sfx_active.play();
			Monster.line_is_active = true;
			$SFX/LoopedLine.play();
		
		if current_mouse_pos != last_mouse_pos:
			line.add_point(current_mouse_pos);
			var line_size : int = len(line.points);
			if line_size>2:
				
				var end_point_id : int = line_size-1;
				var last_segment = [line.get_point_position(end_point_id-1), line.get_point_position(end_point_id)];
				for i in range(0, end_point_id-2):
					var current_segment = [line.get_point_position(i), line.get_point_position(i+1)];
					if segments_intersect(last_segment[0], last_segment[1],
					current_segment[0], current_segment[1]):
						var x1 = last_segment[0][0]; var y1 = last_segment[0][1];
						var x2 = last_segment[1][0]; var y2 = last_segment[1][1];
						var x3 = current_segment[0][0]; var y3 = current_segment[0][1];
						var x4 = current_segment[1][0]; var y4 = current_segment[1][1];
						var denom = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
						var section_point : Vector2;
						if denom == 0:
							section_point = last_segment[1]; # lines are parallel or coincident
						else:
							var t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / denom;
							section_point = Vector2((x1 + t * (x2-x1)), (y1 + t * (y2-y1))); # (px, py) is the intersection
						
						# Create new loop
						line.set_point_position(i, section_point);
						var new_loop = preload("res://Scenes/loop.tscn").instantiate();
						add_child(new_loop);
						for d in range(i+1, end_point_id-1, 2):
							new_loop.add_point(line.get_point_position(i));
							line.remove_point(i); line.remove_point(i+1);
						new_loop.add_point(line.get_point_position(i));
						line.remove_point(i);
						break;
				
				if line_size>max_points:
					line.remove_point(0);
			start_dot.position = line.get_point_position(0);
			last_mouse_pos = current_mouse_pos;
	
	elif len(line.points):
		if Monster.line_is_active:
			sfx_active.stop();
			Monster.line_is_active = false;
			line_is_done.emit();
		line.clear_points();
		last_mouse_pos = Vector2(-1, -1);
		start_dot.position = current_mouse_pos;
	
	else:
		start_dot.position = current_mouse_pos;


func witchCraft(a : Array) -> Array:
	var size_a := len(a);
	for i in range(size_a-1, 0, -1):
		a.append(a[i]);
	return a


func line_broke():
	sfx_break.play(); #sfx_active.stop();
	line_is_broken.emit();
	line.clear_points();
	line_coll.set_polygon(line.get_points());
	

func _on_line_collision_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if "EnnemyCollision" in area.name: line_broke();


func _on_rigara_rigara_roared(): if Monster.line_is_active: line_broke();
