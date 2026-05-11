extends ColorRect

func _ready():
	# Começa a contar 8 segundos assim que a fase abre
	await get_tree().create_timer(6.0).timeout
	sumir_caixa()

func _input(event):
	# ao apertar Enter ou Espaço, a caixa some na hora
	if event.is_action_pressed("ui_accept"):
		sumir_caixa()

func sumir_caixa():
	# Verifica se a caixa ainda está na tela e deleta ela
	if is_inside_tree():
		queue_free()