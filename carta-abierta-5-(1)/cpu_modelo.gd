class_name CPUModelo
extends JugadorModelo

var estrategia: EstrategiaIA

func _init(p_nombre: String = "CPU"):
	super(p_nombre)
	estrategia = IAAleatoria.new()

func cambiar_estrategia(nueva_estrategia: EstrategiaIA):
	estrategia = nueva_estrategia

func jugar_turno(contexto: Dictionary):
	var carta_elegida = estrategia.elegir_carta(mano, contexto)
	if carta_elegida:
		mano.erase(carta_elegida)
	return carta_elegida
