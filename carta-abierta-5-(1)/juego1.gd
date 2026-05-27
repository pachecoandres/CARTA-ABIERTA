extends Node2D

# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  TRIO GANADOR  (3 elementos: Acoso, Empatia, Denuncia)                     ║
# ║  Junta 3 cartas con los 3 colores DISTINTOS y:                            ║
# ║     - los 3 del mismo elemento, O                                          ║
# ║     - los 3 de elementos distintos                                         ║
# ╚══════════════════════════════════════════════════════════════════════════╝

var CartaEscena = preload("res://carta.tscn")

var mazo: MazoModelo
var jugador: JugadorModelo
var cpu: CPUModelo

var cartas_mano_nodos = []
var carta_jugador = null
var carta_cpu = null

var juego_terminado: bool = false

# Cartas-trofeo a cada lado (constancia visual)
var nodos_trofeo_j = []
var nodos_trofeo_cpu = []

func _ready():
	RenderingServer.set_default_clear_color(Color("#1A1F35"))

	mazo = MazoModelo.new()
	mazo.barajar()

	jugador = JugadorModelo.new("Jugador 1")
	cpu = CPUModelo.new("CPU Rival")
	cpu.cambiar_estrategia(IAAleatoria.new())

	jugador.mano = mazo.robar_mano(5)
	cpu.mano     = mazo.robar_mano(5)

	for i in range(5):
		var carta = CartaEscena.instantiate()
		add_child(carta)
		carta.configurar(jugador.mano[i])
		carta.position = Vector2(460 + i * 200, 800)
		cartas_mano_nodos.append(carta)

	print("Tu turno - elige una carta")

	$VentanaConfirmar.visible = false
	$BtnVolver.pressed.connect(_mostrar_confirmacion)
	$VentanaConfirmar/BtnSi.pressed.connect(_volver_menu)
	$VentanaConfirmar/BtnNo.pressed.connect(_cerrar_confirmacion)
	$VentanaVictoria.visible = false
	$VentanaVictoria/ColorRect/BtnOk.pressed.connect(_volver_menu)
	$VentanaVictoria/ColorRect/BtnRejugar.pressed.connect(_rejugar)

	$LabelVictoriasJ.text   = "🏅 Tus tríos:"
	$LabelVictoriasCPU.text = "🤖 Tríos CPU:"
	$LabelResultado.text = "¡Junta tu trío ganador!"

	$LabelCartasJ.visible = false
	$LabelCartasCPU.visible = false

	_actualizar_constancia()

func carta_seleccionada(datos_carta, carta_nodo):
	if juego_terminado or carta_jugador != null:
		return
	carta_jugador = datos_carta
	print("Jugaste: ", datos_carta.elemento, " ", datos_carta.valor)

	var indice = cartas_mano_nodos.find(carta_nodo)
	jugador.mano.erase(datos_carta)

	if mazo.quedan_cartas():
		var nueva_carta = mazo.robar_carta()
		jugador.mano.append(nueva_carta)
		carta_nodo.configurar(nueva_carta)
	else:
		carta_nodo.queue_free()
		cartas_mano_nodos.remove_at(indice)

	jugar_cpu()

func jugar_cpu():
	var contexto = {"ultimo_elemento_jugador": carta_jugador.elemento}
	carta_cpu = cpu.jugar_turno(contexto)
	print("CPU jugó: ", carta_cpu.elemento, " ", carta_cpu.valor)

	var carta_visual = CartaEscena.instantiate()
	add_child(carta_visual)
	carta_visual.configurar(carta_cpu)
	carta_visual.bloqueada = true
	carta_visual.position = Vector2(885, 300)
	_borrar_luego(carta_visual, 1.5)

	resolver_turno()

func resolver_turno():
	var resultado_valor = carta_jugador.gana_contra(carta_cpu)
	var resultado_texto = ""

	if resultado_valor == 1:
		resultado_texto = "¡Ganaste la ronda! +1 carta"
		jugador.victorias.append(carta_jugador)
		_agregar_trofeo(carta_jugador, true)
		resultado_texto += "\n💬 " + _mensaje_victoria()
	elif resultado_valor == -1:
		resultado_texto = "CPU gana la ronda"
		cpu.victorias.append(carta_cpu)
		_agregar_trofeo(carta_cpu, false)
		resultado_texto += "\n💬 " + _mensaje_derrota()
	else:
		resultado_texto = "Empate (nadie suma)"

	$LabelResultado.text = resultado_texto

	$LabelResultado.text = resultado_texto
	_actualizar_constancia()

	if jugador.ha_ganado():
		_terminar("🏆 ¡GANASTE! Lograste el trío")
	elif cpu.ha_ganado():
		_terminar("💀 La CPU logró su trío")

	carta_jugador = null

	if mazo.quedan_cartas():
		cpu.mano.append(mazo.robar_carta())

func _actualizar_constancia():
	var texto_j = "🏅 Tus tríos:\n"
	var texto_cpu = "🤖 Tríos CPU:\n"

# Aparece la carta ganada a un costado (jugador: izq, CPU: der)
func _agregar_trofeo(carta_modelo, es_jugador: bool):
	var mini = CartaEscena.instantiate()
	add_child(mini)
	mini.configurar(carta_modelo)
	mini.bloqueada = true
	mini.scale = Vector2(0.55, 0.55)

	if es_jugador:
		var idx = nodos_trofeo_j.size()
		mini.position = Vector2(60, 250 + idx * 130)
		nodos_trofeo_j.append(mini)
	else:
		var idx = nodos_trofeo_cpu.size()
		mini.position = Vector2(1650, 250 + idx * 130)
		nodos_trofeo_cpu.append(mini)

func _borrar_luego(nodo, segundos: float):
	await get_tree().create_timer(segundos).timeout
	if is_instance_valid(nodo):
		nodo.queue_free()

func _terminar(mensaje: String):
	juego_terminado = true
	$VentanaVictoria/ColorRect/LabelMensaje.text = mensaje
	$VentanaVictoria.visible = true

func _mostrar_confirmacion():
	$VentanaConfirmar.visible = true

func _cerrar_confirmacion():
	$VentanaConfirmar.visible = false

func _volver_menu():
	get_tree().change_scene_to_file("res://menu.tscn")

func _rejugar():
	get_tree().change_scene_to_file("res://juego1.tscn")

func _salir_app():
	get_tree().quit()
	
func _mensaje_victoria() -> String:
	var mensajes = [
		"Defenderte está bien. Pedir ayuda también.",
		"Reconocer el acoso es el primer paso para frenarlo.",
		"No estás solo: hablar fortalece.",
		"Poner límites no es agresión, es respeto propio.",
		"Tu voz tiene poder contra el acoso."
	]
	return mensajes[randi() % mensajes.size()]

func _mensaje_derrota() -> String:
	var mensajes = [
		"Si te superan, busca a un adulto de confianza.",
		"Caer no es fracasar: cuéntale a alguien lo que pasó.",
		"No tienes que enfrentarlo solo, pide apoyo.",
		"El acoso nunca es culpa de quien lo sufre.",
		"Denunciar no es delatar, es protegerte."
	]
	return mensajes[randi() % mensajes.size()]
