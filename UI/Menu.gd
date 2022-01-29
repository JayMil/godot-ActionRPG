extends Control


onready var startButton = $VBoxContainer/StartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.grab_focus()


func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_OptionButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
