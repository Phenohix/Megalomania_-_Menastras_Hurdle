extends  Dialogs

class_name Dialogs_FR

static func relastra(dialogue):
	match dialogue:
		RELASTRA_1:
			print("Hm. Donc tu es mon dernier soldat, c'est ça?");
			menastra(MENASTRA_1);
			print("Bon, tant pis. J'imagine que ça ne me fera pas de mal " +
			"de faire plus attention à partir de maintenant.");
		RELASTRA_2:
			print("Rends toi utile et débarasse moi de tout ça que je puisse me reposer.");
			menastra(MENASTRA_2);
		_:
			print("Ce dialogue n'existe pas.")

static func menastra(dialogue):
	match dialogue:
		MENASTRA_1:
			print("Indeed my lord. You \"disposed\" of all the others already. Along with our people.");
			print("Exact seigneur. Vous avez déjà \"disposé\" de tous les autres. Avec nos gens.");
		MENASTRA_2:
			print("Évidemment.");
		_:
			print("Ce dialogue n'existe pas.")
