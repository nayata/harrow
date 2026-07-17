package harrow;

class Logic {
	public static function variable(entry:String) {
		var key = entry.split(Library.KEY);

		var name = key.shift();
		var type = key.shift();
		var prop = key.join(Library.SPACE);

		switch (type) {
			case "=":
				set(name, string(prop));
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
			case "%":
				var a = float(name);
				var b = float(prop);
				
				set(name, Std.string(a % b));
			case "chance":
				var prob = Random.chance(string(prop));

				set(name, Std.string(prob));
			case "roll":
				var roll = Random.dice(string(prop));

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
			case "is", "==", "=":
				result = string(name) == string(prop);
			case "!=":
				result = string(name) != string(prop);
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
				result = Random.chance(string(prop));
			default:
		}
		
		return result;
	}

	static inline function float(entry:String):Float {
		var number = Std.parseFloat(string(entry));
		if (Math.isNaN(number)) {
			trace('Warning: "${entry}" is not a number, defaulting to 0');
			return 0;
		}

		return number;
	}

	static function string(entry:String):String {
		if (entry == "false" || entry == "true") return entry;
		if (Storage.has(entry)) return Storage.get(entry);

		return entry;
	}

	static function set(entry:String, value:String) {
		Storage.set(entry, value);
	}
}