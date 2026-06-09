extends CharacterBody2D

var velocidade = 150.0
var direcao = 1 
var esta_morto = false 

# --- NOVIDADE: A vida do Mini Chefe ---
var vidas_chefe = 2 

const MOEDA_SCENE = preload("res://moeda.tscn")

func _physics_process(delta: float) -> void:
	# 1. Gravidade
	if not is_on_floor():
		velocity.y += 1200 * delta
		
	# Se ele estiver morto, ele não anda mais (velocidade horizontal zera)
	if esta_morto:
		velocity.x = 0
		move_and_slide()
		return 

	# 2. Movimento horizontal
	velocity.x = direcao * velocidade
	move_and_slide()

	# 3. Inteligência Artificial (IA)
	if is_on_wall() or not $RayCast2D.is_colliding():
		direcao *= -1
		$Sprite2D.flip_h = ! $Sprite2D.flip_h
		$RayCast2D.position.x *= -1

func _on_area_dano_body_entered(body: Node2D) -> void:
	if esta_morto:
		return
		
	if body.name == "cavaleiro":
		if body.has_method("tomar_dano"):
			body.tomar_dano()
		else:
			print("❌ ERRO: O inimigo achou o cavaleiro, mas não achou a função tomar_dano()!")

# ATUALIZAÇÃO: A batalha do Mini Chefe (2 Hits)
func tomar_dano():
	# Evita que ele tome dano depois de morto
	if esta_morto:
		return
		
	# Tira 1 vida do chefe
	vidas_chefe -= 1
	
	if vidas_chefe == 1:
		# --- SOBREVIVEU AO 1º HIT ---
		# Pisca vermelho para o jogador saber que acertou
		modulate = Color(1, 0, 0) 
		await get_tree().create_timer(0.2).timeout
		modulate = Color(1, 1, 1) # Volta a cor normal
		
	elif vidas_chefe <= 0:
		# --- AGORA SIM, MORREU ---
		esta_morto = true
		
		# Desativa o Hurtbox para ele não dar dano caindo
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		
		# Lógica do Drop
		var nova_moeda = MOEDA_SCENE.instantiate()
		get_parent().add_child(nova_moeda)
		nova_moeda.global_position = global_position
		
		# Animação de morte e sumir
		$AnimationPlayer.play("morte")
		await $AnimationPlayer.animation_finished
		queue_free()
