class_name NPCData
extends Resource

var docs: Array[DocData] = []
var motivos: Array[String] = []          # vacío = válido

func es_valido() -> bool:
	return motivos.is_empty()

func doc(tipo: String) -> DocData:
	for d in docs:
		if d.tipo == tipo:
			return d
	return null
