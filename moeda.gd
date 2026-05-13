extends Area2D

func _on_body_entered(body):
	# Verifica se quem encostou na moeda foi exatamente o Cavaleiro
	if body.name == "cavaleiro":
		Global.moedas += 1
		queue_free()
