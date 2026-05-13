extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Isso faz o HUD mostrar sempre o que estiver guardado no Global
	$HUDFase2/ContadorMoedas.text = "Moedas: " + str(Global.moedas)

func _on_moeda_body_entered(_body):
	pass # Isso serve apenas para o sinal não dar erro ao "bater na porta"
