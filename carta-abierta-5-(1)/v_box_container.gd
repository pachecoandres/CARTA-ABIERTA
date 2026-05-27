extends VBoxContainer

const DELAY_ENTRADA = 1.2  # espera a que terminen cartas y título

func _ready():
	# Empieza invisible
	modulate.a = 0.0
	
	await get_tree().create_timer(DELAY_ENTRADA).timeout
	_animar_entrada()
	
	# Conecta hover a cada botón
	for btn in get_children():
		btn.mouse_entered.connect(_on_hover_enter.bind(btn))
		btn.mouse_exited.connect(_on_hover_exit.bind(btn))

func _animar_entrada():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.6)

func _on_hover_enter(btn: Button):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	# Brillo dorado al hacer hover
	tween.tween_property(btn, "modulate", Color(1.4, 1.2, 0.6, 1.0), 0.15)

func _on_hover_exit(btn: Button):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	# Vuelve al color normal
	tween.tween_property(btn, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
