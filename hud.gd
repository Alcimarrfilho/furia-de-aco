extends CanvasLayer

@onready var coracao1 = $Coracao1
@onready var coracao2 = $Coracao2
@onready var coracao3 = $Coracao3
@onready var texto_moedas = $TextoMoedas

@onready var tela_derrota = $"../TelaDerrota" 

func _process(_delta):
	if texto_moedas:
		texto_moedas.text = str(Global.moedas)

# Esta função será chamada pelo script da fase quando o cavaleiro cair
func atualizar_coracoes(vidas_atuais):
	if vidas_atuais == 3:
		coracao1.visible = true
		coracao2.visible = true
		coracao3.visible = true
	elif vidas_atuais == 2:
		coracao1.visible = true
		coracao2.visible = true
		coracao3.visible = false
	elif vidas_atuais == 1:
		coracao1.visible = true
		coracao2.visible = false
		coracao3.visible = false
	else:
		coracao1.visible = false
		coracao2.visible = false
		coracao3.visible = false
		
		if tela_derrota:
			tela_derrota.visible = true    
			get_tree().paused = true       
