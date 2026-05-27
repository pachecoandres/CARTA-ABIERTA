class_name IAAleatoria
extends EstrategiaIA

# Estrategia FÁCIL: elige una carta al azar.

func elegir_carta(mano_cpu: Array, contexto: Dictionary):
	if mano_cpu.size() == 0:
		return null
	return mano_cpu[randi() % mano_cpu.size()]
