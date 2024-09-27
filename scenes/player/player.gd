class_name Player
extends CharacterBody2D

signal health_changed(value: int)

const MOVE_SPEED: float = 40.0
const ACCELERATION: float = 10.0
const MAX_HEALTH: int = 5

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animations: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var _hit_animations: AnimationPlayer = $Sprite2D/HitAnimationPlayer
@onready var _weapon: Weapon
@onready var _hurt_sound: AudioStreamPlayer2D = $HurtSound

@export var input_map: PlayerInputMap
@export var health: int = MAX_HEALTH:
	set = set_health
@export var dead_scene: PackedScene

var _invulernable: bool = false

func _ready() -> void:
	if get_tree().get_nodes_in_group(&"Player").size() == 1:
		_weapon = preload("res://scenes/weapons/weapon_melee.tscn").instantiate()
	else:
		_weapon = preload("res://scenes/weapons/weapon_ranged.tscn").instantiate()
		_sprite.material.set_shader_parameter("palette_swap", true)
	_weapon.collision_mask = 8
	add_child(_weapon)
	
	if input_map.look_mouse:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(_delta: float) -> void:
	var input_move: Vector2 = Input.get_vector(input_map.move_left, input_map.move_right, input_map.move_up, input_map.move_down)
	var target_velocity: Vector2 = Vector2.ZERO
	if input_move:
		target_velocity = input_move * MOVE_SPEED
	
	var input_look: Vector2
	if input_map.look_mouse:
		input_look = get_local_mouse_position().normalized()
	else:
		input_look = Input.get_vector(input_map.look_left, input_map.look_right, input_map.look_up, input_map.look_down)
	
	if input_look:
		_weapon.rotate_to(input_look)
	
	var input_attack: bool = Input.is_action_pressed(input_map.attack)
	if input_attack and not _weapon.is_attacking():
		_weapon.attack()
	
	velocity = velocity.move_toward(target_velocity, ACCELERATION)
	
	if velocity.length() > 0:
		move_and_slide()
		_animations.play(&"move")
		_sprite.flip_h = velocity.x < 0
	else:
		_animations.play(&"idle")


func set_health(value: int) -> void:
	health = clamp(value, 0, MAX_HEALTH)
	health_changed.emit(health)


func hit(_attacker: Node2D, _push: float) -> bool:
	if not _invulernable:
		_invulernable = true
		_hit_animations.play(&"hit")
		health -= 1
		_hurt_sound.play()
		if health <= 0:
			if input_map.look_mouse:
				Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			var dead: Sprite2D = dead_scene.instantiate()
			dead.position = position
			dead.flip_h = _sprite.flip_h
			dead.material.set_shader_parameter("palette_swap", _sprite.material.get_shader_parameter("palette_swap"))
			Events.add_node_to_map.emit(dead)
			
			queue_free()
		return true
	return false


func heal() -> bool:
	if health < MAX_HEALTH:
		health += 1
		return true
	return false


func _on_hit_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"hit":
		_invulernable = false
