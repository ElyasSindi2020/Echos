extends CharacterBody2D

signal healthChanged
signal lost

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_collision: CollisionShape2D = $hurtBox / CollisionShape2D
@onready var hit_sound: AudioStreamPlayer2D = $hit_sound

@export var SPEED = 120.0
const JUMP_VELOCITY = -350.0

@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth

@export var fireball_scene: PackedScene = preload("res://scenes/fireball.tscn")

var isDead = false

func _physics_process(delta: float) -> void :
	if isDead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction: = Input.get_axis("left", "right")


	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void :
	if area.name == "hitBox":
		currentHealth -= 1
		healthChanged.emit(currentHealth)
		hit_sound.play()
	if currentHealth <= 0:
		die()

func die():
	isDead = true
	animated_sprite.stop()
	animated_sprite.play("death")
	hurt_collision.call_deferred("set_disabled", true)
	await animated_sprite.animation_finished
	lost.emit()
