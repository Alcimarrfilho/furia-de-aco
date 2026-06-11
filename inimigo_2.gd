extends CharacterBody2D

# Configurações de movimento e combate
const SPEED = 50.0  
const JUMP_VELOCITY = -400.0 
const PATROL_TIME = 3.0 
const ATTACK_COOLDOWN = 1.5 

# === AQUI ESTÁ A MÁGICA QUE FALTAVA ===
@export var hp = 3 
@export var projetil_cena: PackedScene # Esta linha cria o campo no Inspetor!
var is_dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Referências aos nós filhos 
@onready var sprite = $AnimatedSprite2D
@onready var area_ataque = $AreaAtaque
@onready var ray_muro = $RayMuro
@onready var ray_chao = $RayChao

# Variáveis de controle de estado
var direcao = 1 
var player = null
var is_attacking = false
var can_attack = true

func _ready():
	sprite.play("andar")

func _physics_process(delta):
	if is_dead:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta

	if player != null:
		var direcao_player = sign(player.global_position.x - global_position.x)
		if direcao_player != 0:
			direcao = direcao_player
			virar_sprite()
			
		if can_attack and is_on_floor():
			velocity.x = 0 
			atacar()
	else:
		patrulhar()

	move_and_slide()

# LÓGICA DE MOVIMENTO E PATRULHA 

func patrulhar():
	velocity.x = direcao * SPEED
	sprite.play("andar")
	virar_sprite()
	
	if is_on_wall() or not ray_chao.is_colliding():
		direcao *= -1
		ray_muro.target_position.x *= -1
		ray_chao.target_position.x *= -1

func virar_sprite():
	if direcao > 0:
		sprite.flip_h = false 
	elif direcao < 0:
		sprite.flip_h = true  

# LÓGICA DE COMBATE ATUALIZADA 

func atacar():
	is_attacking = true
	can_attack = false
	sprite.play("atacar") 
	
	#  O CÓDIGO NOVO QUE JOGA O TREM 
	if projetil_cena != null:
		var novo_trem = projetil_cena.instantiate()
		novo_trem.global_position = global_position
		novo_trem.global_position.y -= 10 # Sobe um pouquinho para sair da mão
		novo_trem.direcao = direcao
		
		if direcao < 0:
			novo_trem.scale.x = -1
		
		get_parent().add_child(novo_trem)
	
	print("Ninja jogou o trem!")
	
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true
	is_attacking = false

#  SISTEMA DE VIDA E MORTE 

func receber_dano(quantidade):
	if is_dead: return 
	
	hp -= quantidade
	print("Ninja tomou dano! HP restante: ", hp)
	
	if hp <= 0:
		morrer()

func morrer():
	is_dead = true
	velocity.x = 0 
	
	$CollisionShape2D.disabled = true
	print("O Ninja Amarelo morreu!")
	
	await get_tree().create_timer(3.0).timeout
	queue_free() 

#  CONEXÕES DE SINAIS 

func _on_area_ataque_body_entered(body):
	if body is CharacterBody2D:
		if body.is_in_group("player") or "cavaleiro" in body.name.to_lower():
			player = body

func _on_area_ataque_body_exited(body):
	if body == player:
		player = null