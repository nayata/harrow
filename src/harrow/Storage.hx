package harrow;

class Storage {
	public static var variable:Map<String, String> = new Map();

	
	public static function get(key:String):String {
		return variable.get(key);
	}

	public static function set(key:String, value:String) {
		variable.set(key, value);
	}

	public static function has(key:String):Bool {
		return variable.exists(key);
	}

	public static function remove(key:String) {
		if (has(key)) variable.remove(key);
	}

	public static function clear() {
		variable.clear();
	}
}