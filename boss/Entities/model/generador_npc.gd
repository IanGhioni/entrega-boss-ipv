class_name GeneradorNPC

const NOMBRES := ["Aelar", "Thalia", "Borin", "Mirela", "Kael", "Sorrel", "Dwenn", "Tarkus"]

const RAZAS := ["Humano", "Elfo", "Enano", "Mediano", "Orco", "Tiefling", "Dracónido",
		"Goblin", "Goliat", "Drow", "Sátiro", "Semi bestia", "Gnomo", "Tritón"]

# Para cada clase, las razas a las que se les permite el paso (las X de la tabla).
const RAZAS_POR_CLASE := {
	"Guerrero":   ["Humano", "Enano", "Mediano", "Orco", "Dracónido", "Goliat", "Semi bestia", "Tritón"],
	"Mago":       ["Humano", "Elfo", "Mediano", "Tiefling", "Dracónido", "Goblin", "Drow", "Gnomo", "Tritón"],
	"Bárbaro":    ["Humano", "Enano", "Orco", "Tiefling", "Dracónido", "Goblin", "Goliat", "Sátiro"],
	"Paladín":    ["Humano", "Elfo", "Enano", "Orco", "Dracónido", "Goliat", "Semi bestia", "Tritón"],
	"Nigromante": ["Elfo", "Mediano", "Tiefling", "Goblin", "Goliat", "Drow", "Gnomo"],
	"Santero":    ["Elfo", "Enano", "Mediano", "Tiefling", "Dracónido", "Drow", "Sátiro", "Gnomo"],
	"Druida":     ["Elfo", "Enano", "Mediano", "Orco", "Dracónido", "Goblin", "Sátiro", "Semi bestia", "Tritón"],
	"Clérigo":    ["Humano", "Enano", "Mediano", "Orco", "Goblin", "Goliat", "Drow", "Semi bestia", "Gnomo"],
	"Caballero":  ["Humano", "Enano", "Orco", "Tiefling", "Dracónido", "Goliat", "Sátiro", "Semi bestia", "Tritón"],
	"Pícaro":     ["Humano", "Elfo", "Mediano", "Orco", "Goblin", "Drow", "Sátiro", "Semi bestia", "Tritón"],
	"Brujo":      ["Elfo", "Mediano", "Orco", "Tiefling", "Goblin", "Drow", "Gnomo"],
	"Arquero":    ["Humano", "Elfo", "Enano", "Tiefling", "Dracónido", "Drow", "Semi bestia", "Tritón"],
	"Bardo":      ["Humano", "Elfo", "Enano", "Mediano", "Tiefling", "Drow", "Sátiro", "Gnomo"],
	"Espadachín": ["Humano", "Elfo", "Enano", "Orco", "Dracónido", "Goblin", "Goliat", "Sátiro", "Semi bestia", "Tritón"],
}

# Razas sin entrada acá todavía no tienen sellos definidos (se ignoran las reglas de sello).
const SELLOS_POR_RAZA := {
	"Humano":      ["B", "N", "H", "G", "D", "A"],
	"Elfo":        ["X", "A", "D", "Q", "M", "Z"],
	"Enano":       ["A", "E", "F", "M", "Q", "W"],
	"Mediano":     ["B", "E", "F", "H", "N", "W"],
	"Orco":        ["D", "G", "M", "U", "W", "Z"],
	"Tiefling":    ["A", "N", "Q", "U", "X", "Z"],
	"Dracónido":   ["D", "G", "H", "M", "U", "X"],
	"Goblin":      ["B", "E", "F", "G", "N", "Z"],
	"Goliat":      ["A", "H", "M", "Q", "U", "W"],
	"Drow":        ["D", "E", "F", "Q", "X", "Z"],
	"Sátiro":      ["B", "F", "G", "N", "U", "W"],
	"Semi bestia": ["A", "E", "H", "M", "N", "U"],
	"Gnomo":       ["B", "D", "F", "Q", "W", "X"],
	"Tritón":      ["E", "G", "H", "N", "X", "Z"],
}
const LETRAS := "ABDEFGHMNQUWXZ"
const SIMBOLOS_TOTAL := 17
const SIMBOLOS_CANTIDAD := 5
const PROB_INVALIDO := 0.55

const RAZAS_CON_PASE_VACACIONES := [
	"Enano",
	"Mediano",
	"Goblin",
	"Gnomo"
]

const ELEMENTOS := ["aire", "fuego", "tierra", "agua"]

const ELEMENTO_POR_RAZA := {
	"Humano": "aire", "Tiefling": "aire", "Semi bestia": "aire",
	"Elfo": "agua", "Drow": "agua", "Sátiro": "agua", "Tritón": "agua",
	"Enano": "tierra", "Mediano": "tierra", "Goblin": "tierra", "Gnomo": "tierra",
	"Orco": "fuego", "Dracónido": "fuego", "Goliat": "fuego",
}

# Años legales por elemento (los ✓ de la tabla).
const ANIOS_POR_ELEMENTO := {
	"fuego":  [1361, 1363, 1365, 1367, 1369],
	"agua":   [1362, 1364, 1366, 1369],
	"tierra": [1361, 1362, 1365, 1366, 1368],
	"aire":   [1363, 1364, 1367, 1368],
}
const ANIO_MIN := 1361
const ANIO_MAX := 1369

static func generar() -> NPCData:
	var npc := NPCData.new()
	var d := _doc_valido()
	npc.docs.append(d)

	if randf() < PROB_INVALIDO:
		var defectos := _defectos_aplicables(d)
		defectos.shuffle()
		var cantidad_defectos := randi_range(1, mini(2, defectos.size()))
		var elegidos := defectos.slice(0, cantidad_defectos)

		if "elemento_incorrecto" in elegidos:
			elegidos.erase("anio_ilegal")

		for defecto in elegidos:
			_aplicar(d, defecto)

	npc.motivos = validar(npc)
	return npc

static func _doc_valido() -> DocData:
	var d := DocData.new()
	d.tipo = "comun"
	d.nombre = NOMBRES.pick_random()
	d.raza = RAZAS.pick_random()
	d.clase = _clases_permitidas(d.raza).pick_random()
	d.sello = SELLOS_POR_RAZA[d.raza].pick_random()

	if d.raza == "Elfo" || d.raza == "Drow":
		d.simbolos = _cadena_valida()
	
	if d.raza in RAZAS_CON_PASE_VACACIONES:
		d.tiene_pase_vacaciones = true
	else:
		d.tiene_pase_vacaciones = false
	
	d.vencimiento_elemento = ELEMENTO_POR_RAZA[d.raza]
	d.vencimiento_anio = ANIOS_POR_ELEMENTO[d.vencimiento_elemento].pick_random()
	
	return d

static func _defectos_aplicables(d: DocData) -> Array:
	var defectos: Array = ["combinacion_invalida", "elemento_incorrecto", "anio_ilegal"]
	if SELLOS_POR_RAZA.has(d.raza):
		defectos.append("sello_falso")
	if d.raza == "Elfo":
		defectos.append("simbolos_incorrectos")	
	if d.raza in RAZAS_CON_PASE_VACACIONES:
		defectos.append("pase_vacaciones_ausente")
		defectos.append("pase_vacaciones_invalido")
	return defectos

static func _aplicar(d: DocData, defecto: String) -> void:
	match defecto:
		"combinacion_invalida":
			var candidatas := RAZAS_POR_CLASE.keys().filter(
					func(c): return d.raza not in RAZAS_POR_CLASE[c])
			if not candidatas.is_empty():
				d.clase = candidatas.pick_random()
		"sello_falso":
			var validos: Array = SELLOS_POR_RAZA[d.raza]
			var candidatas := Array(LETRAS.split("")).filter(func(l): return l not in validos)
			d.sello = candidatas.pick_random()
		"simbolos_incorrectos":
			d.simbolos = _cadena_invalida()
		"pase_vacaciones_ausente":
			d.tiene_pase_vacaciones = false
		"pase_vacaciones_invalido":
			d.pase_vacaciones_valido = false
		"elemento_incorrecto":
			var otros := ELEMENTOS.filter(
					func(e): return e != ELEMENTO_POR_RAZA[d.raza])
			d.vencimiento_elemento = otros.pick_random()
			# El año es legal para el elemento mostrado: el único error es el elemento.
			d.vencimiento_anio = ANIOS_POR_ELEMENTO[d.vencimiento_elemento].pick_random()
		"anio_ilegal":
			var legales: Array = ANIOS_POR_ELEMENTO[d.vencimiento_elemento]
			var ilegales := range(ANIO_MIN, ANIO_MAX + 1).filter(
					func(a): return a not in legales)
			d.vencimiento_anio = ilegales.pick_random()

static func validar(npc: NPCData) -> Array[String]:
	var m: Array[String] = []
	var d := npc.doc("comun")

	if d.raza not in RAZAS_POR_CLASE[d.clase]:
		m.append("Combinación no permitida: %s %s" % [d.raza, d.clase])

	if SELLOS_POR_RAZA.has(d.raza) and d.sello not in SELLOS_POR_RAZA[d.raza]:
		m.append("Sello familiar no admitido para su raza")

	if d.raza == "Elfo" and not _es_cadena_valida(d.simbolos):
		m.append("Símbolos élficos incorrectos")
	
	if d.raza in RAZAS_CON_PASE_VACACIONES:
		if not d.tiene_pase_vacaciones:
			m.append("No presenta el pase de vacaciones obligatorio")
		elif not d.pase_vacaciones_valido:
			m.append("Pase de vacaciones inválido")
			
	if ELEMENTO_POR_RAZA[d.raza] != d.vencimiento_elemento:
		m.append("Elemento de vencimiento no corresponde a su raza")
	elif d.vencimiento_anio not in ANIOS_POR_ELEMENTO[d.vencimiento_elemento]:
		m.append("Año de vencimiento no permitido para su elemento")
	
	return m

static func _clases_permitidas(raza: String) -> Array:
	return RAZAS_POR_CLASE.keys().filter(func(c): return raza in RAZAS_POR_CLASE[c])

# 5 números distintos entre 1 y 17, de menor a mayor.
static func _cadena_valida() -> Array[int]:
	var pool: Array = range(1, SIMBOLOS_TOTAL + 1)
	pool.shuffle()
	var s: Array[int] = []
	for i in SIMBOLOS_CANTIDAD:
		s.append(pool[i])
	s.sort()
	return s

# Parte de una cadena válida y le rompe la regla de una de dos formas.
static func _cadena_invalida() -> Array[int]:
	var s := _cadena_valida()
	var i := randi_range(0, SIMBOLOS_CANTIDAD - 2)
	if randf() < 0.5:
		s[i + 1] = s[i]            # repite un valor
	else:
		var tmp := s[i]            # invierte dos consecutivos
		s[i] = s[i + 1]
		s[i + 1] = tmp
	return s

static func _es_cadena_valida(s: Array[int]) -> bool:
	if s.size() != SIMBOLOS_CANTIDAD:
		return false
	for i in s.size():
		if s[i] < 1 or s[i] > SIMBOLOS_TOTAL:
			return false
		if i > 0 and s[i] <= s[i - 1]:
			return false
	return true

# para el tutorial

static func generarValido() -> NPCData:
	var npc := NPCData.new()
	var d := _doc_valido()
	npc.docs.append(d)

	npc.motivos = validar(npc)
	return npc

static func generarInvalido() -> NPCData:
	var npc := NPCData.new()
	var d := _doc_valido()
	npc.docs.append(d)
	
	_aplicar(d, "sello_falso")

	npc.motivos = validar(npc)
	return npc
