extends Control

var modelo   # CartaModelo o CartaModeloR

func configurar(carta_m):
	modelo = carta_m
	$Elemento.text = carta_m.emoji + " " + carta_m.elemento
	$Valor.text = str(carta_m.valor)

	match carta_m.color:
		"rojo":
			$BandasColor.color = Color("#E8364A")
		"azul":
			$BandasColor.color = Color("#4A8FE7")
		"verde":
			$BandasColor.color = Color("#22C55E")

func _ready():
	pass

var bloqueada = false

func _gui_input(event):
	if bloqueada:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			seleccionar()

func seleccionar():
	print("Carta seleccionada: ", modelo.elemento, " ", modelo.valor)
	# Resalto carta
	$Fondo.color = Color("2c3d73ff")
	get_parent().carta_seleccionada(modelo, self)
