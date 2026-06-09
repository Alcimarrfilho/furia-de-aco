extends CanvasLayer

# A função _process roda o tempo todo, atualizando a tela instantaneamente
func _process(delta):
	# 1. Atualiza os corações (exatamente com a mesma inteligência da Fase 1)
	$Coracao1.visible = Global.vidas >= 1
	$Coracao2.visible = Global.vidas >= 2
	$Coracao3.visible = Global.vidas >= 3
	
	# 2. Atualiza o texto do Contador de Moedas
	$ContadorMoedas.text = "Moedas: " + str(Global.moedas)
