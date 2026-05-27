class_name JugadorModelo
extends RefCounted

var nombre: String
var mano: Array = []          # CartaModelo (Trio) o CartaModeloR (Resistencia)
var victorias: Array = []     # Cartas ganadas (Trio Ganador)
var vida: int = 100           # Vida (Resistencia)

func _init(p_nombre: String):
	nombre = p_nombre

# ── TRIO GANADOR ─────────────────────────────────────────────────────────────
# Gana quien junte 3 cartas con los 3 colores distintos y:
#   - los 3 del mismo elemento, O
#   - los 3 de elementos distintos
func ha_ganado() -> bool:
	if victorias.size() < 3:
		return false

	for i in range(victorias.size()):
		for j in range(victorias.size()):
			for k in range(victorias.size()):
				if i == j or j == k or i == k:
					continue

				var v1 = victorias[i]
				var v2 = victorias[j]
				var v3 = victorias[k]

				# Opción 1: mismo COLOR los tres, pero ELEMENTOS distintos
				var mismo_color = (v1.color == v2.color and v2.color == v3.color)
				var elementos_distintos = (v1.elemento != v2.elemento and v2.elemento != v3.elemento and v1.elemento != v3.elemento)
				if mismo_color and elementos_distintos:
					return true

				# Opción 2: mismo ELEMENTO los tres, pero COLORES distintos
				var mismo_elemento = (v1.elemento == v2.elemento and v2.elemento == v3.elemento)
				var colores_distintos = (v1.color != v2.color and v2.color != v3.color and v1.color != v3.color)
				if mismo_elemento and colores_distintos:
					return true

	return false

# ── RESISTENCIA ──────────────────────────────────────────────────────────────
func recibir_dano(cantidad: int):
	vida -= cantidad
	if vida < 0:
		vida = 0

func esta_derrotado() -> bool:
	return vida <= 0
