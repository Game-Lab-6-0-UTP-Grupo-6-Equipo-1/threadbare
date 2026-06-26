class_name Carta extends Node2D

@export_category("Narrativa")

@export var dialogo_carta: DialogueResource

@export var titulo_dialogo: StringName = ""

@export_category("Estado")

@export var revealed: bool = true:
	set(new_value):
		revealed = new_value
		_actualizar_estado()

# Referencias a los nodos hijos
@onready var interact_area: InteractArea = $InteractArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal leida

func _ready() -> void:
	_actualizar_estado()
	
	if Engine.is_editor_hint():
		return
		
	# Conectamos la señal de interacción
	if interact_area:
		interact_area.action = "Leer carta"
		interact_area.interaction_started.connect(self._on_interacted)

func _actualizar_estado() -> void:
	if animated_sprite:
		animated_sprite.modulate = Color.WHITE if revealed else Color.TRANSPARENT
	if interact_area:
		interact_area.disabled = not revealed

func _on_interacted(player: Player, _from_right: bool) -> void:
	if dialogo_carta:
		DialogueManager.show_dialogue_balloon(dialogo_carta, titulo_dialogo, [self, player])
		await DialogueManager.dialogue_ended
	
	interact_area.end_interaction()
	interact_area.disabled = true
	
	if animation_player and animation_player.has_animation("collected"):
		animation_player.play("collected")
		await animation_player.animation_finished
	
	# === NUEVO: Emitimos la señal avisando que se leyó ===
	leida.emit() 
	
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not dialogo_carta:
		warnings.append("¡Falta asignar el recurso de diálogo para esta carta!")
	return warnings
