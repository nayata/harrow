package harrow;

class Random {
	public function new() {}

	public function chance(entry:String):Bool {
		return roll(0, 100) < Std.parseInt(entry);
	}

	public function dice(entry:String):Int {
		return roll(1, Std.parseInt(entry));
	}

	function roll(min:Int, max:Int):Int {
		return min + Math.floor(((max - min + 1) * Math.random()));
	}
}