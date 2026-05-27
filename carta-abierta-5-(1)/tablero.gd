extends Node2D

var CartaEscena = preload("res://carta.tscn")

var mazo: MazoModeloR
var jugador: JugadorModelo
var cpu: CPUModelo

var cartas_mano_nodos = []
var carta_jugador = null
var carta_cpu = null

var juego_terminado: bool = false

func _ready():
	RenderingServer.set_default_clear_color(Color("#1A1F35"))

	mazo = MazoModeloR.new()
	mazo.barajar()

	jugador = JugadorModelo.new("Jugador 1")
	cpu = CPUModelo.new("CPU Rival")
	cpu.cambiar_estrategia(IAAleatoria.new())

	jugador.vida = 100
	cpu.vida     = 100

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

	$LabelVictoriasJ.text   = "⚔️  Tu Vida:"
	$LabelVictoriasCPU.text = "🛡️  Vida CPU:"
	$LabelResultado.text = "¡Protege tu resistencia!"

	_personajes_idle()
	_actualizar_barras()


func _actualizar_barras():
	$LabelCartasJ.text   = _barra(jugador.vida) + "  " + str(jugador.vida) + "%"
	$LabelCartasCPU.text = _barra(cpu.vida)     + "  " + str(cpu.vida)     + "%"

func _barra(valor: int) -> String:
	var llenas = int(valor / 10.0)
	var texto = ""
	for i in range(10):
		texto += "█" if i < llenas else "░"
	return texto


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
	_borrar_luego(carta_visual, 1.8)

	resolver_turno()


func resolver_turno():
	var resultado_valor = carta_jugador.gana_contra(carta_cpu)
	var resultado_texto = ""

	if resultado_valor == 1:
		var dano = carta_jugador.valor
		cpu.recibir_dano(dano)
		resultado_texto = "¡Golpeas! -" + str(dano) + " a la CPU"
		$LabelResultado.text = resultado_texto
		_ejecutar_animacion_personaje(carta_jugador.elemento, 1)
	elif resultado_valor == -1:
		var dano = carta_cpu.valor
		jugador.recibir_dano(dano)
		resultado_texto = "Te golpean -" + str(dano) + " de vida"
		$LabelResultado.text = resultado_texto
		_ejecutar_animacion_personaje(carta_cpu.elemento, -1)
	else:
		resultado_texto = "Empate (sin daño)"
		$LabelResultado.text = resultado_texto
		_personajes_idle()

	_actualizar_barras()

	if cpu.esta_derrotado():
		_terminar("🏆 ¡GANASTE! Venciste a la CPU")
	elif jugador.esta_derrotado():
		_terminar("💀 Tu resistencia llegó a 0")

	carta_jugador = null

	if mazo.quedan_cartas():
		cpu.mano.append(mazo.robar_carta())

func _terminar(mensaje: String):
	juego_terminado = true
	$VentanaVictoria/ColorRect/LabelMensaje.text = mensaje
	$VentanaVictoria.visible = true

func _borrar_luego(nodo, segundos: float):
	await get_tree().create_timer(segundos).timeout
	if is_instance_valid(nodo):
		nodo.queue_free()


func _get_personaje_j():
	return get_node_or_null("Personaje_Jugador")

func _get_personaje_cpu():
	return get_node_or_null("Personaje_CPU")

func _get_burbuja():
	return null

func _play_anim(sprite, nombre_anim: String):
	if sprite == null:
		return
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(nombre_anim):
		sprite.play(nombre_anim)

func _personajes_idle():
	_play_anim(_get_personaje_j(), "idle")
	_play_anim(_get_personaje_cpu(), "idle")
	var b = _get_burbuja()
	if b != null:
		b.visible = false

func _ejecutar_animacion_personaje(elemento: String, resultado: int):
	var pj  = _get_personaje_j()
	var pcpu = _get_personaje_cpu()
	
	var mensaje = ""

	if resultado == 1:
		# La víctima supo defenderse
		_play_anim(pj, "escudo")
		_play_anim(pcpu, "temblar")
	elif resultado == -1:
		# La víctima no supo defenderse
		_play_anim(pj, "caer")
		_play_anim(pcpu, "poder")
	else:
		mensaje = "A veces no hay respuesta perfecta, sigue intentando."

	# Mensaje de concienciación debajo del resultado

	if pj == null and pcpu == null:
		return

	await get_tree().create_timer(2.0).timeout
	_personajes_idle()

func _mostrar_burbuja(texto: String, sprite_ref):
	var b = _get_burbuja()
	if b == null or sprite_ref == null:
		return
	var lbl = b.get_node_or_null("Label")
	if lbl != null:
		lbl.text = texto
	b.position = sprite_ref.position + Vector2(0, -60)
	b.visible = true

# ── Ventanas ─────────────────────────────────────────────────────────────────
func _mostrar_confirmacion():
	$VentanaConfirmar.visible = true

func _cerrar_confirmacion():
	$VentanaConfirmar.visible = false

func _volver_menu():
	get_tree().change_scene_to_file("res://menu.tscn")

func _rejugar():
	get_tree().change_scene_to_file("res://tablero.tscn")

func _salir_app():
	get_tree().quit()
