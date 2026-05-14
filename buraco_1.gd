extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "cavaleiro":
		# 1. Tira a vida do cavaleiro primeiro
		if Global.has_method("perder_vida"):
			Global.perder_vida()
			
		# 2. Recarrega a fase atual do zero
		get_tree().reload_current_scene()
