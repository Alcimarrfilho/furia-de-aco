extends Area2D

func _on_body_entered(body):
	#  O "in" verifica se a palavra 'cavaleiro' faz parte do nome do objeto.
	if "cavaleiro" in body.name:
		Global.moedas += 1
		print("Moeda coletada! Total: ", Global.moedas)
		
		var label_moedas = get_tree().current_scene.find_child("TextoMoedas", true, false)
		if label_moedas:
			label_moedas.text = str(Global.moedas)
		
		# Remove a moeda do cenário
		queue_free()
