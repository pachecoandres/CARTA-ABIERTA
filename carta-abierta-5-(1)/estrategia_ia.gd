class_name EstrategiaIA
extends RefCounted

# Clase abstracta para el patrón Strategy

func elegir_carta(mano_cpu: Array, contexto: Dictionary):
	if mano_cpu.size() == 0:
		return null
	return mano_cpu[0]
