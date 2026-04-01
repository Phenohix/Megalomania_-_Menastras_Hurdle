extends Node2D

signal rigara_roared();

@onready var overlay = $Body/RigaraOverlay
@onready var underlay = $Body/RigaraUnderlay
@onready var anim = $AnimationPlayer
@onready var attTimer = $AttackTimer

@onready var marked_pos = $"../BossMarker".position
@onready var to_place : bool = false;
@onready var hp : int = 200;

var overlay_texture : Array[Texture2D] = [preload("res://Art/Bosses/Rigara/Rigara_Head_eyeopen.png"),
	preload("res://Art/Bosses/Rigara/Rigara_Maw_jaw.png")];
var underlay_texture : Array[Texture2D] = [preload("res://Art/Bosses/Rigara/Rigara_Head_normal.png"),
	preload("res://Art/Bosses/Rigara/Rigara_Maw_mouth.png")];


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack_preparation":
		overlay.texture = overlay_texture[1];
		underlay.texture = underlay_texture[1];
		anim.play("attacking");
		$RigaraRoar.play();
		rigara_roared.emit();
	if anim_name == "attacking":
		overlay.texture = overlay_texture[0];
		underlay.texture = underlay_texture[0];
		anim.play("RESET");
		attTimer.start(randi()%5+11);

func _physics_process(delta):
	if to_place:
		position.y += 250 * delta;
		if position.y >= marked_pos.y:
			to_place = false;
			position = marked_pos
			anim.play("attack_preparation");
			$DistorsionRect.show();


func _on_ennemy_container_boss_phase():
	to_place = true;
	#attTimer.start(randi()%5+13);


func _on_attack_timer_timeout(): anim.play("attack_preparation");
