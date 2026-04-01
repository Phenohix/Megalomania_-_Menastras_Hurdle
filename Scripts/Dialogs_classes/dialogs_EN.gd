extends  Dialogs

class_name Dialogs_EN


static func relastra(dialog):
	match dialog:
		RELASTRA_1:
			print("Hm. So you are my last soldier, right?");
			menastra(MENASTRA_1);
			print("Oh, well. I guess it won't hurt me to be a little more careful from now on.");
		RELASTRA_2:
			print("Be useful and rid me of all this pest so I can rest.");
			menastra(MENASTRA_2);
		_:
			print("This dialog does not exist.")

static func menastra(dialog):
	match dialog:
		MENASTRA_1:
			print("Indeed my lord. You \"disposed\" of all the others already. Along with our people.");
		MENASTRA_2:
			print("Of course.");
		_:
			print("This dialog does not exist.")
