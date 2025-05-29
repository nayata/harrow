class Dice extends harrow.Random {
	override public function chance(entry:String):Bool {
		return roll(0, 100) < Std.parseInt(entry);
	}

	override public function dice(entry:String):Int {
		var text = entry.toLowerCase();
		var keys = text.split("d");

		if (keys.length == 1) return roll(1, Std.parseInt(text));

		var pool = Std.parseInt(keys.shift());
		var side = keys.shift();

		var type = side.charAt(side.length-1);
		if (type == "h" || type == "l") {
			side = side.substring(0, side.length-1);
		}

		var rolls:Array<Int> = [];
		var total:Int = 0;

		for (i in 0...pool) {
			var take = roll(1, Std.parseInt(side));
			total = total + take;
			rolls.push(take);
		}

		rolls.sort((a, b) -> a - b);

		if (type == "l") return rolls.shift();
		if (type == "h") return rolls.pop();

		return total;
	}
}