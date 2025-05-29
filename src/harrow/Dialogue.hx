package harrow;

class Dialogue {
	public static function get(entry:String):Array<Choice> {
		var map = entry.split(Library.LINE);
		var choices = [];

		for (i in 0...map.length) {
			var key = map[i].split(Library.ITEM);

			var choice = new Choice();

			choice.text = key[0];
			choice.type = key[1];
			choice.data = key[2];
			choice.mode = key[3];
			choice.role = key[4];

			choices.push(choice);
		}

		return choices;
	}
}