extends Label

const DURACION_ENTRADA = 0.8
const BOB_ALTURA = 8.0       # píxeles que sube y baja
const BOB_VELOCIDAD = 0.5    # ciclos por segundo

var pos_base : Vector2
var tiempo : float = 0.0
var animacion_lista : bool = false

func _ready():
	# Guarda la posición original
	pos_base = position
	
	# Empieza invisible y pequeño
	scale = Vector2(0.0, 0.0)
	modulate.a = 0.0
	
	# Pequeño delay para que entre después de las cartas
	await get_tree().create_timer(0.6).timeout
	
	_animar_entrada()

func _animar_entrada():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	# Zoom in desde 0 hasta tamaño normal
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), DURACION_ENTRADA)
	
	# Fade in al mismo tiempo
	tween.tween_property(self, "modulate:a", 1.0, DURACION_ENTRADA * 0.6)
	
	await tween.finished
	animacion_lista = true

func _process(delta):
	if not animacion_lista:
		return
	
	# Efecto bob suave con seno
	tiempo += delta
	var offset = sin(tiempo * BOB_VELOCIDAD * TAU) * BOB_ALTURA
	position.y = pos_base.y + offset
