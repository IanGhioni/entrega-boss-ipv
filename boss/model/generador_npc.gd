class_name GeneradorNPC

const NOMBRES := ["Aelar", "Thalia", "Borin", "Mirela", "Kael", "Sorrel", "Dwenn", "Tarkus"]
const CLASES := ["Guerrero", "Mago", "Pícaro", "Clérigo", "Bardo"]
const SELLOS_POR_RAZA := {
	"Humano": ["B", "N", "H", "G", "D", "A"],
	"Elfo":   ["X", "A", "D", "Q", "M", "Z"],
}
const RAZAS := ["Humano", "Elfo"]
const LETRAS := "ABDEFGHMNQUWXZ"
const SIMBOLOS_VALIDOS: Array[int] = [1, 2, 3, 4, 5]
const SIMBOLOS_TOTAL := 17
const PROB_INVALIDO := 0.5

static func generar() -> NPCData:
	var npc := NPCData.new()
	var d := _doc_valido()
	npc.docs.append(d)

	if randf() < PROB_INVALIDO:
		var defectos := _defectos_aplicables(d)
		defectos.shuffle()
		for i in randi_range(1, mini(2, defectos.size())):
			_aplicar(d, defectos[i])

	npc.motivos = validar(npc)
	return npc

static func _doc_valido() -> DocData:
	var d := DocData.new()
	d.tipo = "comun"
	d.nombre = NOMBRES.pick_random()
	d.clase = CLASES.pick_random()
	d.raza = RAZAS.pick_random()
	d.sello = SELLOS_POR_RAZA[d.raza].pick_random()
	if d.raza == "Elfo":
		d.simbolos = SIMBOLOS_VALIDOS.duplicate()
	return d

static func _defectos_aplicables(d: DocData) -> Array:
	if d.raza == "Elfo":
		return ["sello_falso", "simbolos_incorrectos"]
	return ["sello_falso"]

static func _aplicar(d: DocData, defecto: String) -> void:
	match defecto:
		"sello_falso":
			var validos: Array = SELLOS_POR_RAZA[d.raza]
			var candidatas := Array(LETRAS.split("")).filter(func(l): return l not in validos)
			d.sello = candidatas.pick_random()
		"simbolos_incorrectos":
			var s: Array[int] = []
			while s.size() < 5 or s == SIMBOLOS_VALIDOS:
				s.clear()
				for i in 5:
					s.append(randi_range(1, SIMBOLOS_TOTAL))
			d.simbolos = s

static func validar(npc: NPCData) -> Array[String]:
	var m: Array[String] = []
	var d := npc.doc("comun")

	if d.sello not in SELLOS_POR_RAZA[d.raza]:
		m.append("Sello familiar no admitido para su raza")

	if d.raza == "Elfo" and d.simbolos != SIMBOLOS_VALIDOS:
		m.append("Símbolos élficos incorrectos")
	return m
