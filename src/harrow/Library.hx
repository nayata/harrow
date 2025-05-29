package harrow;

class Library {
	public static var LF:String = "\n";

	public static var EMPTY:String = "";
	public static var SPACE:String = " ";
	public static var COLON:String = "::";
	public static var LINE:String = "|";
	public static var ITEM:String = "::";
	public static var COMA:String = ",";
	public static var DASH:String = "-";
	public static var KEY:String = ":";

	public static var parseSpeaker:Bool = true;

	static var TYPE:Int = 0;
	static var TEXT:Int = 1;
	static var DATA:Int = 2;
	static var PROP:Int = 3;
	

	public static function get(entry:String):Story {
		// LF character : 'Line Feed' or 'Newline Character'
		var res = entry.split(LF);

		var story = new Story();
		var line:Int = 0;

		while (line < res.length) {
			var node = getNode(res, line);
			
			if (node != null && node.type != EMPTY) {
				var page = new Page();

				page.type = node.type;
				page.text = node.text;
				page.data = node.data;

				story.data.push(page);

				line += node.depth;
			}
			line++;
		}

		return story;
	}


	public static function getNode(res:Array<String>, page:Int):Null<Node> {
		var string = StringTools.trim(res[page]);
		if (string.length == 0) return null;

		var node = new Node();
		var type = Page.TEXT;

		var leading = string.substring(0, 1);

		if (leading == "#") type = Page.ROUTE;
		if (leading == "-") type = Page.DIALOGUE;
		if (leading == "[") type = isEvent(string);
		if (leading == "/") type = EMPTY;

		if (isBreak(string)) type = Page.BREAK;
		
		node.type = type;

		if (type == Page.TEXT) {
			getText(node, string);
		}

		if (type == Page.ROUTE) {
			var route = StringTools.replace(string, "#", "");
			node.text = StringTools.trim(route);
		}
		
		if (type == Page.DIALOGUE) {
			getDialogue(node, res, page);
		}
		
		if (type == Page.EVENT) {
			getEvent(node, string);
		}

		return node;
	}


	static function getText(node:Node, res:String) {
		var raw = StringTools.replace(res, COLON, LINE);
		var key = raw.split(KEY);

		node.text = StringTools.trim(key.pop());
		node.text = StringTools.replace(node.text, LINE, KEY);
		node.data = key.length > 0 ? StringTools.trim(key[TYPE]) : "";

		if (!parseSpeaker) node.text = res;
	}


	static function getDialogue(node:Node, res:Array<String>, indent:Int) {
		var dialogue:Array<String> = [];
		
		for (page in indent...res.length) {
			var sampled = StringTools.trim(res[page]);
			
			var allowed = sampled.substring(0, 2) != DASH+DASH;
			var leading = sampled.substring(0, 1);

			if (leading == DASH && allowed) {
				dialogue.push(res[page]);
			}
			else {
				break;
			}
		}
		
		var content = "";
		var string = "";
		
		for (i in 0...dialogue.length) {
			string = dialogue[i];
			
			string = StringTools.replace(string, DASH, "");
			string = getDialogueItem(string);
			
			var divider = LINE;
			if (i == dialogue.length - 1) divider = "";
			
			content = content + string + divider;
		}
		
		node.text = content;
		node.data = dialogue.length == 1 ? "button" : "dialogue";
		node.depth = dialogue.length - 1;
	}


	static function getDialogueItem(res:String):String {
		var key = res.split(KEY);
				
		var text = StringTools.trim(key[TYPE]);
		var type = "empty";
		var data = "empty";
		var mode = "empty";
		var role = "empty";
		
		if (key.length > 1) {
			var string = StringTools.trim(key[TEXT]);
			string = StringTools.replace(string, SPACE, KEY);
			
			var prop = string.split(KEY);
			
			if (isVariable(prop[TEXT])) {
				type = "variable";
				data = string;
			}
			else {
				type = "route";
				data = StringTools.trim(key[TEXT]);
			}
		}

		// Get `mode` and `role`
		if (key.length > 2) {
			mode = StringTools.trim(key[DATA]);
			mode = StringTools.replace(mode, SPACE, KEY);
		}
		if (key.length > 3) {
			role = StringTools.trim(key[PROP]);
			role = StringTools.replace(role, SPACE, KEY);
		}
		
		return text + ITEM + type + ITEM + data + ITEM + mode + ITEM + role;
	}


	static function getEvent(node:Node, res:String) {
		var string = res.substring(1, res.length-1);
		string = StringTools.trim(string);
		
		string = StringTools.replace(string, COMA + SPACE, COMA);
		string = StringTools.replace(string, SPACE + SPACE, KEY);
		string = StringTools.replace(string, SPACE, KEY);

		var key = string.split(KEY);
		var type = key[TYPE];
		
		node.type = Page.EVENT;
		node.text = StringTools.replace(string, type + ":", "");
		node.data = type;
		
		if (type == "move") {
			node.type = Page.MOVE;
			node.text = StringTools.replace(string, "move:", "");
			node.text = StringTools.replace(node.text, KEY, SPACE);
		}

		if (type == "story") {
			node.type = Page.MOVE;
			node.text = StringTools.replace(string, "story:", "");
			node.text = StringTools.replace(node.text, KEY, SPACE);
		}

		if (type == "lock" || type == "close") {
			node.type = Page.MOVE;
			node.text = type;
		}

		if (type == "if") {
			node.type = Page.CONDITION;
			node.text = StringTools.replace(string, "if:", "");
		}

		if (type == "else" || type == "end") {
			node.type = Page.CONDITION;
			node.text = type;
		}

		if (isVariable(key[TEXT])) {
			node.type = Page.VARIABLE;
			node.text = string;
		}
	}


	static function isBreak(entry:String):Bool {
		var leading = entry.substring(0, 2);
		if (leading == DASH+DASH) return true;
		return false;
	}


	static function isEvent(entry:String):String {
		if (entry.indexOf("]") != entry.length-1) return Page.TEXT;
		return Page.EVENT;
	}


	static function isVariable(entry:String):Bool {
		if (entry == "=" || entry == "+" || entry == "-" || entry == "*" || entry == "/") return true;
		if (entry == "is" || entry == "roll" || entry == "chance") return true;
		return false;
	}
}


class Node {
	public var type:String = "";
	public var text:String = "";
	public var data:String = "";
	public var depth:Int = 0;

	public function new() {}
}