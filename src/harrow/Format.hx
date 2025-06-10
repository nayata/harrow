package harrow;

class Format {
	public static function variable(entry:String):String {
		if (entry.indexOf("[") == -1) return entry;

		var rex:EReg = ~/\[(.*?)\]/gi;

		entry = rex.map(entry, function(r) {
			var matching = r.matched(0);
			var variable = matching.substring(1, matching.length-1);

			if (Storage.has(variable)) return Storage.get(variable);
			return matching;
		});

		return entry;
	}

	public static function string(entry:String):String {
		return StringTools.replace(entry, Library.KEY, Library.SPACE);
	}

	public static function from(entry:String):Array<String> {
		return entry.split(Library.KEY);
	}

	public static function to(entry:Array<String>):String {
		return entry.join(Library.KEY);
	}
}