extends Node2D

func _ready():
	var all_eyes = [$GadromLegM/GadromEyeLegM, $GadromTower/GadromEyeHat, $GadromTower/GadromEyeTopL, $GadromTower/GadromEyeTopR, $GadromTower/GadromEyeMiddle, $GadromTower/GadromEyeBottom, $GadromLegL/GadromEyeLegL];
	var tower_parts = [$GadromLegM, $GadromTower, $GadromHingeL, $GadromLegL, $GadromHingeR, $GadromLegR];
	var tower_color = randi_range(80, 255);
	var ran_tow_color : Color = Color.from_rgba8(tower_color, tower_color, tower_color, 255);
	for tower in tower_parts:
		tower.modulate = ran_tow_color;
	
	var color_list = [255, randi_range(0, 255), 0];
	color_list.shuffle();
	var ran_eye_color : Color = Color.from_rgba8(
		color_list[0], color_list[1], color_list[2],
	255);
	for eye in all_eyes:
		eye.modulate = ran_eye_color;
