class_name MazoModeloR
extends RefCounted

var cartas_disponibles: Array[CartaModeloR] = []

func _init():
	_generar_baraja()

func _generar_baraja():
	cartas_disponibles.clear()

	# Acoso (😈)
	cartas_disponibles.append(CartaModeloR.new("Acoso", 2, "rojo", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 5, "azul", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 8, "verde", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 11, "rojo", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 3, "verde", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 7, "azul", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 10, "rojo", "😈"))
	cartas_disponibles.append(CartaModeloR.new("Acoso", 12, "verde", "😈"))

	# Empatia (🤝)
	cartas_disponibles.append(CartaModeloR.new("Empatia", 3, "azul", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 6, "verde", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 9, "rojo", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 12, "azul", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 2, "verde", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 5, "rojo", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 8, "azul", "🤝"))
	cartas_disponibles.append(CartaModeloR.new("Empatia", 11, "verde", "🤝"))

	# Denuncia (📣)
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 1, "verde", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 4, "rojo", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 7, "azul", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 10, "verde", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 3, "rojo", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 6, "azul", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 9, "verde", "📣"))
	cartas_disponibles.append(CartaModeloR.new("Denuncia", 12, "rojo", "📣"))

	# Apoyo (💪)
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 2, "rojo", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 5, "azul", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 8, "verde", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 11, "rojo", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 4, "azul", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 7, "verde", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 10, "rojo", "💪"))
	cartas_disponibles.append(CartaModeloR.new("Apoyo", 13, "azul", "💪"))

	# PoderEspecial (⚡)
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 3, "verde", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 6, "rojo", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 9, "azul", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 12, "verde", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 2, "rojo", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 5, "azul", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 8, "verde", "⚡"))
	cartas_disponibles.append(CartaModeloR.new("PoderEspecial", 11, "rojo", "⚡"))

func barajar():
	cartas_disponibles.shuffle()

func quedan_cartas() -> bool:
	return cartas_disponibles.size() > 0

func robar_carta() -> CartaModeloR:
	if quedan_cartas():
		return cartas_disponibles.pop_front()
	return null

func robar_mano(cantidad: int) -> Array[CartaModeloR]:
	var mano: Array[CartaModeloR] = []
	for i in range(cantidad):
		var c = robar_carta()
		if c:
			mano.append(c)
	return mano
