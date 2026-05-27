class_name CartaModelo
extends RefCounted

var elemento: String
var valor: int
var color: String
var emoji: String

func _init(p_elemento: String, p_valor: int, p_color: String, p_emoji: String):
	elemento = p_elemento
	valor = p_valor
	color = p_color
	emoji = p_emoji

# Devuelve 1 si esta carta gana, -1 si pierde, 0 si empata
func gana_contra(otra_carta: CartaModelo) -> int:
	if elemento == otra_carta.elemento:
		if valor > otra_carta.valor:
			return 1
		elif valor < otra_carta.valor:
			return -1
		return 0

	var jerarquia = {
		"Acoso": "Empatia",
		"Empatia": "Denuncia",
		"Denuncia": "Acoso"
	}

	if jerarquia[elemento] == otra_carta.elemento:
		return 1
	return -1
