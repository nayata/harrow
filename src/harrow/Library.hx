package harrow;

class Library {
	public static var SPACE:String = " ";
	public static var LINE:String = "|";
	public static var ITEM:String = "::";
	public static var COMA:String = ",";
	public static var HASH:String = "#";
	public static var DASH:String = "-";
	public static var KEY:String = ":";
	
	public static var colonEscape:String = "::";
	public static var validate:Bool = true;

	static var TYPE:Int = 0;
	static var TEXT:Int = 1;
	static var DATA:Int = 2;
	static var PROP:Int = 3;


	public static function get(entry:String):Story {
		var res = entry.split("\n");

		var story = new Story();
		var last:Null<Page> = null;

		for (line in res) {
			var page = parse(line);
			var skip = merge(page, last);

			if (page == null) last = null;
			if (page == null) skip = true;

			if (skip == false) {
				story.data.push(page);
				last = page;
			}
		}

		if (validate) Syntax.validate(story);

		return story;
	}


	public static function parse(entry:String):Null<Page> {
		var string = StringTools.trim(entry);

		if (string.length == 0) return null;
		if (string.substring(0, 1) == "/") return null;

		var page = new Page();
		page.type = Page.TEXT;

		var leading = string.substring(0, 1);

		if (leading == "#") page.type = Page.ROUTE;
		if (leading == "-") page.type = Page.DIALOGUE;
		if (leading == "[") page.type = isEvent(string);

		if (isBreak(string)) page.type = Page.BREAK;
		
		switch (page.type) {
			case Page.TEXT: getText(page, string);
			case Page.ROUTE: getRoute(page, string);
			case Page.DIALOGUE: getDialogue(page, string);
			case Page.EVENT: getEvent(page, string);
		}

		return page;
	}


	public static function merge(page:Page, last:Page):Bool {
		if (page != null && page.type == Page.DIALOGUE && last != null && last.type == Page.DIALOGUE) {
			last.text = last.text + LINE + page.text;
			last.data = "dialogue";
			return true;
		}
		return false;
	}


	static function getText(page:Page, entry:String) {
		var raw = StringTools.replace(entry, colonEscape, LINE);
		var key = raw.indexOf(":");
	
		page.text = StringTools.trim(key >= 0 ? raw.substr(key + 1) : raw);
		page.data = key >= 0 ? StringTools.trim(raw.substr(0, key)) : "";
		
		page.text = StringTools.replace(page.text, LINE, KEY);

		var open = page.data.indexOf("<");
		var close = page.data.indexOf(">");

		if (open != -1 && close > open) {
			page.tags = page.data.substr(open + 1, close - open - 1);
			page.data = page.data.substr(0, open);
		}
	}


	static function getRoute(page:Page, entry:String) {
		var locked = entry.substring(0, 2) != HASH + HASH;

		page.text = StringTools.trim(StringTools.replace(entry, HASH, ""));
		page.data = locked ? "route" : "label";
	}


	static function getDialogue(page:Page, entry:String) {
		var res = StringTools.replace(entry, DASH, "");
		var key = res.split(KEY);
				
		var text = StringTools.trim(key[TYPE]);
		var type = "empty";
		var data = "empty";
		var mode = "empty";
		
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
		if (key.length > 2) {
			mode = StringTools.trim(key[DATA]);
			mode = StringTools.replace(mode, SPACE, KEY);
		}
		
		page.text = text + ITEM + type + ITEM + data + ITEM + mode;
		page.data = "button";
	}


	static function getEvent(page:Page, entry:String) {
		var string = entry.substring(1, entry.length-1);
		string = StringTools.trim(string);
		
		string = StringTools.replace(string, COMA + SPACE, COMA);
		string = StringTools.replace(string, SPACE + SPACE, KEY);
		string = StringTools.replace(string, SPACE, KEY);

		var key = string.split(KEY);
		var type = key[TYPE];
		
		page.type = Page.EVENT;
		page.text = StringTools.replace(string, type + ":", "");
		page.data = type;
		
		if (type == "story" || type == "move") {
			page.type = Page.MOVE;
			page.text = StringTools.replace(page.text, KEY, SPACE);
		}
		if (type == "lock" || type == "close") {
			page.type = Page.MOVE;
		}
		if (type == "if") {
			page.type = Page.CONDITION;
			page.text = StringTools.replace(string, "if:", "");
		}
		if (type == "else" || type == "end") {
			page.type = Page.CONDITION;
			page.text = type;
		}
		if (isVariable(key[TEXT])) {
			page.type = Page.VARIABLE;
			page.text = string;
		}
	}


	static function isBreak(entry:String):Bool {
		return entry.length >= 2 && entry.substring(0, 2) == DASH + DASH;
	}


	static function isEvent(entry:String):String {
		if (entry.indexOf("]") != entry.length-1) return Page.TEXT;
		return Page.EVENT;
	}


	static function isVariable(entry:String):Bool {
		if (entry == "=" || entry == "+" || entry == "-" || entry == "*" || entry == "/") return true;
		if (entry == "roll" || entry == "chance") return true;
		return false;
	}
}