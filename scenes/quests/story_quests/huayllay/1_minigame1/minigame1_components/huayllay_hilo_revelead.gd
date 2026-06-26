class_name HiloPuzzle extends CollectibleItem

## Arrastra aquí las 5 cartas que el jugador debe leer
@export var cartas_necesarias: Array[Carta]

var cantidad_leidas: int = 0

func _ready() -> void:
	# Llama a la configuración base del CollectibleItem
	super()
	
	# Nos aseguramos de que el hilo empiece invisible e inactivo
	self.revealed = false
	
	# Conectamos la señal de cada carta en el arreglo a nuestra función
	for carta in cartas_necesarias:
		if carta:
			carta.leida.connect(self._on_carta_leida)

func _on_carta_leida() -> void:
	cantidad_leidas += 1
	
	# Si la cantidad de cartas leídas es igual al tamaño del arreglo, revelamos el hilo
	if cantidad_leidas >= cartas_necesarias.size():
		reveal()
