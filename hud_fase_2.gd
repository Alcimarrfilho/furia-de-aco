extends CanvasLayer

func _ready() -> void:
	# Roda sempre que a cena começa ou recomeça
	atualizar_coracoes()

func atualizar_coracoes():
	# Pega o número de vidas salvo no seu script Global
	var vidas_restantes = Global.vidas 
	
	# Lógica para esconder os corações de acordo com a vida
	if vidas_restantes == 2:
		$Coracao3.hide() 
		
	elif vidas_restantes == 1:
		$Coracao3.hide()
		$Coracao2.hide()
		
	elif vidas_restantes <= 0:
		$Coracao3.hide()
		$Coracao2.hide()
		$Coracao1.hide()
