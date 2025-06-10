package harrow;

class Random {
	public static dynamic function chance(entry:String):Bool {
		return roll(0, 100) < Std.parseInt(entry);
	}

	public static dynamic function dice(entry:String):Int {
		return roll(1, Std.parseInt(entry));
	}

	public static function roll(min:Int, max:Int):Int {
		return min + Math.floor(((max - min + 1) * Math.random()));
	}
}