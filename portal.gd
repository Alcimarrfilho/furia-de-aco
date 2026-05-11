extends Area2D

func _on_body_entered(body):
	# Verifica se quem encostou no portal foi o cavaleiro
	if body.name == "cavaleiro":
		
		# verificação se tem as 4 moedas
		if Global.moedas >= 4:
			print("Sucesso! Indo para a Fase 2...")
			Global.moedas = 0 # Zera para a próxima fase
			get_tree().change_scene_to_file("res://Fase2.tscn")
			
		else:
			# Se não tiver, avisa no console
			print("Faltam moedas! Você tem apenas: ", Global.moedas)