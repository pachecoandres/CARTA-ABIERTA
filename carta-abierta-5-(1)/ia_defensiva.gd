class_name IADefensiva
extends EstrategiaIA

# Estrategia MEDIA: intenta contrarrestar el elemento del rival.
# Cubre los 5 elementos (si solo hay 3 también funciona).

func elegir_carta(mano_cpu: Array, contexto: Dictionary):
	if mano_cpu.size() == 0:
		return null

	var elemento_rival = contexto.get("ultimo_elemento_jugador", "")

	if elemento_rival != "":
		# Qué elemento le gana a cada elemento rival
		var elemento_que_gana = {
			"Empatia": "Acoso",
			"Denuncia": "Empatia",
			"Apoyo": "Denuncia",
			"PoderEspecial": "Apoyo",
			"Acoso": "PoderEspecial"
		}

		var tipo_buscado = elemento_que_gana.get(elemento_rival, "")

		var mejor = null
		for carta in mano_cpu:
			if carta.elemento == tipo_buscado:
				if mejor == null or carta.valor > mejor.valor:
					mejor = carta
		if mejor != null:
			return mejor

	# Si no tiene counter, tira la de mayor valor
	var mejor_valor = mano_cpu[0]
	for carta in mano_cpu:
		if carta.valor > mejor_valor.valor:
			mejor_valor = carta
	return mejor_valor
