package harrow;

class Story {
	public var name:String = "";
	public var data:Array<Page> = [];
	public var page:Int = -1;
	

	public function new() {}


	public function next():Page {
		if (page < data.length) page = page + 1;
		return data[page];
	}


	public function move(route:String):Int {
		for (i in 0...data.length) {
			if (data[i].type == Page.ROUTE && data[i].text == route) return page = i;
		}
		return page;
	}


	public function skip():Int {
		var position = page + 1;

		for (i in position...data.length) {
			if (data[i].type == Page.CONDITION) {
				if (data[i].text == "end" || data[i].text == "else") return page = i;
			}
		}
		return page;
	}


	public function turn(number:Int):Int {
		if (number < 0 || number > data.length - 1) return page;
		return page = number;
	}


	public function jump(number:Int):Int {
		if (page + number < 0 || page + number > data.length - 1) return page;
		return page = page + number;
	}


	public function look(number:Int):Null<Page> {
		if (number < 0 || number > data.length - 1) return null;
		return data[number];
	}


	public function find(type:String, text:String):Null<Int> {
		for (i in 0...data.length) {
			if (data[i].type == type && data[i].text == text) return i;
			if (text == "any" && data[i].type == type) return i;
			if (type == "any" && data[i].text == text) return i;
		}
		return null;
	}


	public function all(type:String):Array<Page> {
		var array = [];
		for (page in data) {
			if (page.type == type) array.push(page);
		}
		return array;
	}


	public var end(get, never):Bool;
	
	function get_end():Bool {
		return page == data.length - 1;
	}
}