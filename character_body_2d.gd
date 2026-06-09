extends CharacterBody2D

# CONFIGURAÇÕES BÁSICAS
const SPEED = 300.0  
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ESTADOS DO ATAQUE
var attacking = false
var attack_cooldown = 0.0
var pode_tomar_dano = true

# --- NOVIDADES ---
# Memoriza a direção que ele olha: 1 para direita, -1 para esquerda. Começa pra Direita.
var direcao_olhar = 1.0 
# A distância exata da caixa de ataque até o centro do cavaleiro.
# Olhando para o seu print, 40 parece um valor ideal. Se ficar torto, mude!
var ataque_distancia_x = 40.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Aplica Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo (ui_accept é Barra de Espaço por padrão no Godot)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Pega o input de movimento (-1 esquerda, 1 direita)
	var input_direcao = Input.get_axis("ui_left", "ui_right")
	
	# --- ATUALIZAÇÃO DO MOVIMENTO E OLHAR ---
	if input_direcao != 0:
		# Só anda e vira se NÃO estiver atacando (evita que ele ande deslizando no ataque)
		if not attacking:
			velocity.x = input_direcao * SPEED
			# Memoriza a direção do olhar para o Hitbox saber onde ficar
			direcao_olhar = input_direcao
			# Vira o rosto visualmente
			sprite.flip_h = input_direcao < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- CORREÇÃO DA CAIXA DE ATAQUE (Hitbox) ---
	# Esta parte roda SEMPRE, garantindo que a caixa esteja no lugar certo
	# Se olhar para a esquerda (-1), a posição X da caixa fica negativa
	if direcao_olhar < 0:
		$AtaqueArea.position.x = -ataque_distancia_x 
	else:
		# Se olhar para a direita (1), a posição X fica positiva (posição padrão)
		$AtaqueArea.position.x = ataque_distancia_x

	# --- LÓGICA DE ATAQUE E DANO ---
	# Se apertar o botão "atacar" (X, Z, Espaço, o que você criou)
	if Input.is_action_just_pressed("atacar") and is_on_floor() and not attacking:
		attacking = true
		attack_cooldown = 0.6
		sprite.play("attack")
		
		# --- NOVIDADE: Dá o dano! ---
		# Pega todas as áreas (hurtboxes dos inimigos) dentro da caixa roxa agora!
		var areas_atingidas = $AtaqueArea.get_overlapping_areas()
		for area in areas_atingidas:
			if area.name == "Hurtbox":
				# Chama a função tomar_dano() que criamos no script do inimigo
				area.get_parent().tomar_dano()
	
	# Controle do Cooldown do ataque
	if attacking:
		# Garante que a animação continue passando
		if sprite.animation != "attack":
			sprite.animation = "attack"
			sprite.play()
		attack_cooldown -= delta
		# Ataque terminou
		if attack_cooldown <= 0:
			attacking = false

	move_and_slide()

	# Controla as animações SÓ SE não estiver atacando
	if not attacking:
		if not is_on_floor():
			if sprite.animation != "jump":
				sprite.animation = "jump"
				sprite.play()
		elif input_direcao != 0:
			if sprite.animation != "run":
				sprite.animation = "run"
				sprite.play()
		else:
			if sprite.animation != "idle":
				sprite.animation = "idle"
				sprite.play()

func tomar_dano():
	
	# Só toma o dano se o escudo estiver desligado
	if pode_tomar_dano == true:
		
		# 1. Tira a vida lá do Global (a HUD vai atualizar na hora)
		Global.vidas -= 1
		
		# 2. SE A VIDA ZERAR: Morreu de vez! Recarrega a fase.
		if Global.vidas <= 0:
			get_tree().call_deferred("reload_current_scene")
			# Reseta a vida para o próximo play (opcional, dependendo de como você faz o Game Over)
			Global.vidas = 3 
			return # Para a função aqui para ele não tentar ficar vermelho depois de morto
		
		# 3. SE AINDA TEM VIDA: Liga o escudo e pisca vermelho
		pode_tomar_dano = false 
		modulate = Color(1, 0, 0) # Fica vermelhão
		
		# Espera 1 segundo exato (tempo do escudo)
		await get_tree().create_timer(1.0).timeout
		
		# O tempo acabou: volta a cor ao normal e desliga o escudo
		modulate = Color(1, 1, 1) 
		pode_tomar_dano = true
