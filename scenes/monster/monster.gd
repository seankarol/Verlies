class_name Monster
extends CharacterBody2D

enum State {
	CHARGE,
	STUN,
}

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animations: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var _hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var _nav: NavigationAgent2D = $NavigationAgent2D

@export var type: MonsterType
@export var health: int = 1:
	set = set_health

var _weapon: Weapon
var _state: State = State.CHARGE:
	set = _set_state
var _target: Node2D
var _push_direction: Vector2

func _ready() -> void:
	assert(type, "Monsters must have a type!")
	health = type.max_health
	_sprite.texture = type.texture
	_weapon = type.weapon_scene.instantiate()
	_weapon.collision_mask = 4
	add_child(_weapon)
	
	_set_state(_state)


func _physics_process(_delta: float) -> void:
	if not _target or not is_instance_valid(_target):
		_target = null
		var shortest_distance: float
		for player: Player in get_tree().get_nodes_in_group(&"Player"):
			var distance: float = position.distance_to(player.position)
			if not _target or distance < shortest_distance:
				shortest_distance = distance
				_target = player
	
	var target_velocity: Vector2 = Vector2.ZERO
	match _state:
		State.CHARGE:
			var next_position: Vector2 = position
			if _target:
				_nav.target_position = _target.position
				next_position = _nav.get_next_path_position()
			
			var input_move: Vector2 = Vector2.ZERO
			if _target:
				input_move = (next_position - position).normalized()
			
			if input_move:
				target_velocity = input_move * type.move_speed
			
			var input_look: Vector2
			if _target:
				input_look = (_target.position - position).normalized()
			
			if input_look:
				_weapon.rotate_to(input_look)
			
			var input_attack: bool = _should_attack()
			if input_attack and not _weapon.is_attacking():
				_weapon.attack()
			
			velocity = velocity.move_toward(target_velocity, type.acceleration)
			move_and_slide()
			
			if velocity.length() > 0:
				_animations.play(&"move")
				_sprite.flip_h = velocity.x < 0
			else:
				_animations.play(&"idle")
		State.STUN:
			_animations.play(&"stun")
			_push_direction *= 0.9
			velocity = _push_direction
			move_and_slide()


func set_health(value: int) -> void:
	health = max(value, 0)


func hit(attacker: Node2D, push: float) -> bool:
	if _state != State.STUN:	
		var push_direction: Vector2 = (position - attacker.position).normalized()
		_state = State.STUN
		_push_direction = push_direction * (push / type.mass)
		health -= 1
		_hurt_sound.play()
		return true
	return false


func _set_state(value: State) -> void:
	_state = value
	
	if _weapon and &"enabled" in _weapon:
		_weapon.enabled = _state == State.CHARGE


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"stun":
		if health <= 0:
			queue_free()
			Events.slime_died.emit()
		else:
			_state = State.CHARGE


func _should_attack() -> bool:
	if not _target:
		return false
	
	if _weapon is WeaponMelee:
		return position.distance_to(_target.position) <= 16
	
	if _weapon is WeaponRanged:
		return position.distance_to(_target.position) <= 256
	
	return false
