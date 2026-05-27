extends Node2D

# Posiciones de las cartas
const FINAL_Y = 1050.0
const DELAY_BETWEEN_CARDS = 0.15  # segundos entre cada carta

func _ready():
	animate_cards()

func animate_cards():
	var cards = get_children()  #cartas 1 a 5
	
	for i in range(cards.size()):
		var card = cards[i]
		
		# cartas afuera de la pantalla
		card.position.y = 700.0
		card.modulate.a = 0.0  # no visibles
		
		# Crea el Tween
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)   # efecto de rebote
		tween.set_ease(Tween.EASE_OUT)
		
		# delay por cartas
		tween.tween_interval(i * DELAY_BETWEEN_CARDS)
		
		# animacion por posicion
		tween.tween_property(card, "position:y", FINAL_Y, 0.7)
		tween.parallel().tween_property(card, "modulate:a", 1.0, 0.3)
