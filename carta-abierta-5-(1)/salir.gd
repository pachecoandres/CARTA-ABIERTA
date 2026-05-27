extends Button

func _ready():
	# ... lo que ya tienes ...
	$Salir.pressed.connect(_salir)  # Ctrl+arrastra el nodo Salir aquí

func _salir():
	get_tree().quit()
