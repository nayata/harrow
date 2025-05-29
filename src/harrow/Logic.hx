package harrow;

class Logic {
	public static var random:Random = new Random();


	public static function variable(entry:String) {
		var key = entry.split(Library.KEY);

		var name = key.shift();
		var type = key.shift();
		var prop = key.join(Library.SPACE);

		switch (type) {
			case "=":
				set(name, get(prop));
			case "+":
				var a = float(name);
				var b = float(prop);

				set(name, Std.string(a + b));
			case "-":
				var a = float(name);
				var b = float(prop);

				set(name, Std.string(a - b));
			case "*":
				var a = float(name);
				var b = float(prop);

				set(name, Std.string(a * b));
			case "/":
				var a = float(name);
				var b = float(prop);

				set(name, Std.string(a / b));
			case "chance":
				var prob = random.chance(get(prop));

				set(name, Std.string(prob));
			case "roll":
				var roll = random.dice(get(prop));

				set(name, Std.string(roll));
			default:
		}
	}


	public static function condition(entry:String):Bool {
		if (entry == "else") return false;
		if (entry == "end") return true;

		var key = entry.split(Library.KEY);

		var name = key.shift();
		var type = key.shift();
		var prop = key.join(Library.SPACE);
		
		var result = false;
		switch (type) {
			case "is":
				result = get(name) == get(prop);
			case "=":
				result = get(name) == get(prop);
			case "<=":
				var a = float(name);
				var b = float(prop);

				result = a <= b;
			case ">=":
				var a = float(name);
				var b = float(prop);

				result = a >= b;
			case "<":
				var a = float(name);
				var b = float(prop);

				result = a < b;
			case ">":
				var a = float(name);
				var b = float(prop);

				result = a > b;
			case "chance":
				result = random.chance(get(prop));
			default:
		}
		
		return result;
	}


	static function get(entry:String):String {
		if (entry == "false" || entry == "true") return entry;
		if (Storage.has(entry)) return Storage.get(entry);

		return entry;
	}


	static function set(entry:String, value:String) {
		Storage.set(entry, value);
	}


	static inline function float(entry:String):Float {
		return Std.parseFloat(get(entry));
	}
}