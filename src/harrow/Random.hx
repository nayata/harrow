package harrow;

class Random {
	static inline var MAXIMUM:Int = 100;

	public static dynamic function chance(entry:String):Bool {
		return roll(0, 100) < parse(entry, 0);
	}

	public static dynamic function dice(entry:String):Int {
		if (entry == null) return 0;

		var text = StringTools.trim(entry).toLowerCase();
		if (text == "") return 0;

		var index = text.indexOf("d");

		if (index == -1) {
			var max = parse(text, 0);
			return max > 0 ? roll(1, max) : 0;
		}

		var pool = parse(text.substring(0, index), 1);
		var side = text.substring(index + 1);
		var type = side.charAt(side.length - 1);

		if (type == "h" || type == "l") {
			side = side.substring(0, side.length - 1);
		} else {
			type = "";
		}

		var faces = parse(side, 0);
		if (pool < 1 || faces < 1) return 0;
		if (pool > MAXIMUM) pool = MAXIMUM;

		var total = 0;
		var min = faces;
		var max = 1;

		for (i in 0...pool) {
			var take = roll(1, faces);
			total += take;

			if (take < min) min = take;
			if (take > max) max = take;
		}

		return switch (type) {
			case "h": max;
			case "l": min;
			default: total;
		}
	}


	public static function roll(min:Int, max:Int):Int {
		return min + Math.floor(((max - min + 1) * Math.random()));
	}

	static function parse(text:String, fallback:Int):Int {
		var value = Std.parseInt(text);
		if (value == null) return fallback;
		return value;
	}
}