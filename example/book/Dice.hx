class Dice {
	public function new() {}

	public function roll(entry:String):Int {
		var text = entry.toLowerCase();
		var keys = text.split("d");

		if (keys.length == 1) return rollDice(1, Std.parseInt(text));

		var pool = Std.parseInt(keys.shift());
		var side = keys.shift();

		var type = side.charAt(side.length-1);
		if (type == "h" || type == "l") {
			side = side.substring(0, side.length-1);
		}

		var rolls:Array<Int> = [];
		var total:Int = 0;

		for (i in 0...pool) {
			var take = rollDice(1, Std.parseInt(side));
			total = total + take;
			rolls.push(take);
		}

		rolls.sort((a, b) -> a - b);

		if (type == "l") return rolls.shift();
		if (type == "h") return rolls.pop();

		return total;
	}

	function rollDice(min:Int, max:Int):Int {
		return min + Math.floor(((max - min + 1) * Math.random()));
	}
}