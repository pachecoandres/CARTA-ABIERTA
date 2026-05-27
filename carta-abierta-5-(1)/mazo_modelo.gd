class_name MazoModelo
extends RefCounted

var cartas_disponibles: Array[CartaModelo] = []

func _init():
	_generar_baraja()

func _generar_baraja():
	cartas_disponibles.clear()

	# Acoso (😈)
	cartas_disponibles.append(CartaModelo.new("Acoso", 2, "rojo", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 5, "azul", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 8, "verde", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 11, "rojo", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 3, "verde", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 7, "azul", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 10, "rojo", "😈"))
	cartas_disponibles.append(CartaModelo.new("Acoso", 12, "verde", "😈"))

	# Empatia (🤝)
	cartas_disponibles.append(CartaModelo.new("Empatia", 3, "azul", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 6, "verde", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 9, "rojo", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 12, "azul", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 2, "verde", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 5, "rojo", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 8, "azul", "🤝"))
	cartas_disponibles.append(CartaModelo.new("Empatia", 11, "verde", "🤝"))

	# Denuncia (📣)
	cartas_disponibles.append(CartaModelo.new("Denuncia", 1, "verde", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 4, "rojo", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 7, "azul", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 10, "verde", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 3, "rojo", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 6, "azul", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 9, "verde", "📣"))
	cartas_disponibles.append(CartaModelo.new("Denuncia", 12, "rojo", "📣"))

func barajar():
	cartas_disponibles.shuffle()

func quedan_cartas() -> bool:
	return cartas_disponibles.size() > 0

func robar_carta() -> CartaModelo:
	if quedan_cartas():
		return cartas_disponibles.pop_front()
	return null

func robar_mano(cantidad: int) -> Array[CartaModelo]:
	var mano: Array[CartaModelo] = []
	for i in range(cantidad):
		var c = robar_carta()
		if c:
			mano.append(c)
	return mano
