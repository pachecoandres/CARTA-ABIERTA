extends Node2D

@onready var musica = $AudioStreamPlayer2D
@onready var ventana_opciones = $VBoxContainer/Opciones/VentanaOpciones
@onready var ventana_instrucciones = $VBoxContainer/Instrucciones/VentanaInstrucciones
@onready var btn_mute = $VBoxContainer/Opciones/VentanaOpciones/PanelContainer/BotonesContainer/Silenciar
@onready var ventana_personajes = $VentanaPersonajes
@onready var ventana_jugar = $VentanaJugar
@onready var sprite_personaje = $VentanaPersonajes/PanelContainer/VBox/HBox/SpritePersonaje
@onready var lbl_nombre = $VentanaPersonajes/PanelContainer/VBox/LblNombre
@onready var btn_confirmar = $VentanaPersonajes/PanelContainer/VBox/BtnConfirmar

# Lista de personajes
const PERSONAJES = [
	{"sprite": "res://chica1.png"},
	{"sprite": "res://chica2.png"},
	{"sprite": "res://personajes_v2/chico1.png"},
	{"sprite": "res://personajes_v2/chico2.png"},
]

var personaje_actual = 0
var personaje_elegido = 0


var muteado = false

func _ready():
	ventana_opciones.visible = false
	ventana_instrucciones.visible = false
	
	
	# Busca VentanaJugar en el árbol
	var ventana_jugar = find_child("VentanaJugar", true, false)
	print("ventana_jugar encontrada: ", ventana_jugar)
	ventana_jugar.visible = false
	
	$VBoxContainer/Salir.pressed.connect(_salir)
	$VBoxContainer/Opciones.pressed.connect(_abrir_opciones)
	$VBoxContainer/Instrucciones.pressed.connect(_abrir_instrucciones)
	
	$VBoxContainer/Jugar.pressed.connect(_abrir_selector)
	
	$VentanaPersonajes/PanelContainer/VBox/HBox/BtnIzquierda.pressed.connect(_personaje_anterior)
	$VentanaPersonajes/PanelContainer/VBox/HBox/BtnDerecha.pressed.connect(_personaje_siguiente)
	
	$VBoxContainer/Opciones/VentanaOpciones/PanelContainer/BotonesContainer/Cerrar.pressed.connect(_cerrar_opciones)
	$VBoxContainer/Instrucciones/VentanaInstrucciones/PanelContainer/BotonesContainer/Cerrar.pressed.connect(_cerrar_instrucciones)
	$VBoxContainer/Opciones/VentanaOpciones/PanelContainer/BotonesContainer/Silenciar.pressed.connect(_toggle_mute)
	find_child("VentanaJugar", true, false).find_child("Cerrar", true, false).pressed.connect(_cerrar_jugar)
	find_child("VentanaJugar", true, false).find_child("Trio_Ganador", true, false).pressed.connect(_ir_juego1)
	find_child("VentanaJugar", true, false).find_child("Resistencia", true, false).pressed.connect(_ir_juego2)
	
	ventana_personajes.visible = false

	$VentanaPersonajes/PanelContainer/VBox/HBox/BtnIzquierda.pressed.connect(_personaje_anterior)
	$VentanaPersonajes/PanelContainer/VBox/HBox/BtnDerecha.pressed.connect(_personaje_siguiente)
	$VentanaPersonajes/PanelContainer/VBox/HBox/BtnConfirmar.pressed.connect(_confirmar_personaje)

	# Conecta el botón Jugar del menú principal
	$VBoxContainer/Jugar.pressed.connect(_abrir_selector)
	
	
	_actualizar_personaje()

func _abrir_jugar():
	find_child("VentanaJugar", true, false).visible = true
	_animar_ventana_entrada_jugar()

func _cerrar_jugar():
	_animar_ventana_salida_jugar()

func _ir_juego1():
	get_tree().change_scene_to_file("res://juego1.tscn")

func _ir_juego2():
	get_tree().change_scene_to_file("res://tablero.tscn")

func _abrir_opciones():
	ventana_opciones.visible = true
	_animar_ventana_entrada()
	
func _abrir_instrucciones():
	ventana_instrucciones.visible = true
	_animar_ventana_entrada_instrucciones()

var cerrando = false

func _cerrar_opciones():
	if cerrando:
		return
	cerrando = true
	_animar_ventana_salida()

func _cerrar_instrucciones():
	if cerrando:
		return
	cerrando = true
	_animar_ventana_salida_instrucciones()
	
	
func _abrir_personajes():
	ventana_personajes.visible = true
	_animar_entrada_personajes()

func _toggle_mute():
	muteado = !muteado
	musica.volume_db = -80.0 if muteado else 0.0
	btn_mute.text = "Activar Musica" if muteado else "Silenciar Musica"

func _animar_ventana_entrada():
	var panel = $VBoxContainer/Opciones/VentanaOpciones/PanelContainer
	panel.modulate.a = 0.0
	ventana_opciones.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

func _animar_ventana_entrada_instrucciones():
	var panel = $VBoxContainer/Instrucciones/VentanaInstrucciones/PanelContainer
	panel.modulate.a = 0.0
	ventana_instrucciones.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

func _animar_ventana_entrada_jugar():
	var panel = $VentanaJugar/PanelContainer
	panel.modulate.a = 0.0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 3.0)

func _animar_entrada_personajes():
	var panel = $VentanaPersonajes/PanelContainer
	print("panel: ", panel)
	panel.modulate.a = 0.0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

func _animar_ventana_salida():
	var panel = $VBoxContainer/Opciones/VentanaOpciones/PanelContainer
	panel.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(panel, "modulate:a", 0.0, 0.6)
	await tween.finished
	ventana_opciones.visible = false
	panel.modulate.a = 1.0
	cerrando = false

func _animar_ventana_salida_instrucciones():
	var panel = $VBoxContainer/Instrucciones/VentanaInstrucciones/PanelContainer
	panel.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(panel, "modulate:a", 0.0, 0.6)
	await tween.finished
	ventana_instrucciones.visible = false
	panel.modulate.a = 1.0
	cerrando = false

func _animar_ventana_salida_jugar():
	var panel = $VentanaJugar/PanelContainer
	panel.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(panel, "modulate:a", 0.0, 0.6)
	await tween.finished
	ventana_jugar.visible = false
	panel.modulate.a = 1.0
	cerrando = false



func _salir():
	get_tree().quit()
	
func _abrir_selector():
	print("abriendo selector")
	print(ventana_jugar)

	ventana_personajes.visible = true
	_animar_entrada_personajes()

func _cerrar_selector():
	ventana_jugar.visible = false

func _personaje_anterior():
	personaje_actual -= 1

	if personaje_actual < 0:
		personaje_actual = PERSONAJES.size() - 1
	_actualizar_personaje()

func _personaje_siguiente():
	personaje_actual += 1

	if personaje_actual >= PERSONAJES.size():
		personaje_actual = 0
	_actualizar_personaje()

func _actualizar_personaje():
	var p = PERSONAJES[personaje_actual]
	sprite_personaje.texture = load(p["sprite"])
	
	

func _confirmar_personaje():
	personaje_elegido = personaje_actual

	# Cierra selector de personajes
	ventana_personajes.visible = false

	# Abre selector de modos
	ventana_jugar.visible = true

	# Animación de la ventana de modos
	_animar_ventana_entrada_jugar()


	
