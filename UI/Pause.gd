extends CanvasLayer

onready var overlay = $Pause
onready var quitButton = $Pause/VBoxContainer/QuitButton

func _ready():
	overlay.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		overlay.visible = new_pause_state
		quitButton.grab_focus()


func _on_QuitButton_pressed():
	get_tree().quit()
