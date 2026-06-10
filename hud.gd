extends CanvasLayer

@onready var coracao1 = $HBoxContainer/Coracao1
@onready var coracao2 = $HBoxContainer/Coracao2
@onready var coracao3 = $HBoxContainer/Coracao3
@onready var texto_moedas = $TextoMoedas
@onready var tela_derrota = $"../CanvasLayer/TelaDerrota"

# MAPEANDO A NOVA TELA DE PAUSE:
@onready var tela_pause = $"../CanvasLayer/TelaPause"
@onready var btn_continuar = $"../CanvasLayer/TelaPause/VBoxContainer/BotaoContinuar"
@onready var btn_reiniciar = $"../CanvasLayer/TelaPause/VBoxContainer/BotaoReiniciar"
@onready var btn_menu = $"../CanvasLayer/TelaPause/VBoxContainer/BotaoMenu"

func _ready():
	# SEGURANÇA: Garante que as telas comecem escondidas ao carregar o jogo
	if tela_pause: tela_pause.visible = false
	if tela_derrota: tela_derrota.visible = false
	
	# Conecta o botão de Tentar Novamente da Derrota
	var btn_derrota = get_node_or_null("../CanvasLayer/TelaDerrota/VBoxContainer/Button")
	if btn_derrota: 
		btn_derrota.pressed.connect(_on_tentar_novamente_pressed)
		
	# CONECTA OS BOTÕES DA TELA DE PAUSE:
	if btn_continuar: btn_continuar.pressed.connect(_on_continuar_pressed)
	if btn_reiniciar: btn_reiniciar.pressed.connect(_on_reiniciar_pressed)
	if btn_menu: btn_menu.pressed.connect(_on_menu_pressed)

func _input(event):
	# Captura o clique da tecla F5 no teclado
	if event is InputEventKey and event.pressed and event.keycode == KEY_F5:
		# Só abre o pause se o jogador NÃO tiver morrido (tela de derrota visível)
		if tela_derrota and not tela_derrota.visible:
			if get_tree().paused:
				_on_continuar_pressed() # Se já estava pausado, despausa
			else:
				pausar_jogo() # Se estava jogando, pausa

func pausar_jogo():
	if tela_pause: 
		tela_pause.visible = true
	get_tree().paused = true

func _process(_delta):
	# Atualiza o contador de moedas
	if has_node("TextoMoedas") and texto_moedas:
		texto_moedas.text = str(Global.moedas)
	
	# Fica de olho nas vidas do jogador
	atualizar_coracoes(Global.vidas)

# FUNÇÕES DOS BOTÕES DE PAUSE (F5) 

func _on_continuar_pressed():
	if tela_pause: 
		tela_pause.visible = false
	get_tree().paused = false

func _on_reiniciar_pressed():
	Global.vidas = 3
	if tela_pause: 
		tela_pause.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_principal.tscn")

# GERENCIAMENTO DE VIDAS E DERROTA 

func atualizar_coracoes(vidas_atuais):
	if coracao1 and coracao2 and coracao3:
		# Se o jogador tiver 1 ou mais vidas, garante que a tela de derrota suma
		if vidas_atuais >= 1:
			if tela_derrota: tela_derrota.visible = false
		
		# Controla a visibilidade de cada coração baseado na vida atual
		coracao1.visible = vidas_atuais >= 1
		coracao2.visible = vidas_atuais >= 2
		coracao3.visible = vidas_atuais >= 3
		
		# Se a vida zerar, ativa a tela de derrota e pausa o jogo
		if vidas_atuais <= 0:
			if tela_derrota:
				tela_derrota.visible = true
				get_tree().paused = true

func _on_tentar_novamente_pressed():
	Global.vidas = 3
	if tela_derrota: 
		tela_derrota.visible = false      
	get_tree().paused = false             
	get_tree().reload_current_scene()
