extends CanvasLayer


onready var ui = $GameOverUI
onready var playAgainButton = $GameOverUI/VBoxContainer/PlayAgainButton


var active = false setget set_active

var _restart_scene = null

func _ready():
	ui.visible = false

func set_active(value):
	get_tree().paused = value
	ui.visible = value

func game_over(restart_scene):
	self.active = true
	playAgainButton.grab_focus()
	_restart_scene = restart_scene


func _on_PlayAgain_pressed():
	if _restart_scene != null:
# warning-ignore:return_value_discarded
		get_tree().change_scene(_restart_scene)
		self.active = false
		

func _on_QuitButton_pressed():
	get_tree().quit()
