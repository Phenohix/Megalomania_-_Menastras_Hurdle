extends ColorRect

var clearColor = Color.from_rgba8(255, 255, 255, 0)
var obscuredColor = Color.from_rgba8(206, 206, 206, 127)
var redColor = Color.from_rgba8(255, 0, 0, 255)

@onready var miniButton = $MinimiseButton
@onready var maxiButton = $MaximiseButton
@onready var closeButton = $CloseButton

func _ready():
	miniButton.modulate = clearColor;
	maxiButton.modulate = clearColor;
	closeButton.modulate = clearColor;

func _on_minimise_button_mouse_entered(): miniButton.modulate = obscuredColor;
func _on_minimise_button_mouse_exited(): miniButton.modulate = clearColor;

func _on_maximise_button_mouse_entered(): maxiButton.modulate = obscuredColor;
func _on_maximise_button_mouse_exited(): maxiButton.modulate = clearColor;

func _on_close_button_mouse_entered(): closeButton.modulate = redColor;
func _on_close_button_mouse_exited(): closeButton.modulate = clearColor;
