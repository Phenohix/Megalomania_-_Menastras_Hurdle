extends Node

class_name Dialogs

enum {
	RELASTRA_1,
	RELASTRA_2,
	MENASTRA_1,
	MENASTRA_2
}

enum {
	FR,
	EN
}

static var Language = Dialogs_EN; # Default

func change_language(l) -> void :
	match l:
		FR: Language = Dialogs_FR;
		EN: Language = Dialogs_EN;
