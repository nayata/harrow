package harrow;

class Library {
	public static inline var SPACE:String = " ";
	public static inline var LINE:String = "|";
	public static inline var ITEM:String = "::";
	public static inline var COMA:String = ",";
	public static inline var HASH:String = "#";
	public static inline var DASH:String = "-";
	public static inline var KEY:String = ":";

	public static var DIVIDE:String = "\uE000";
	public static var ESCAPE:String = "\\:";

	static var TYPE:Int = 0;
	static var TEXT:Int = 1;
	static var DATA:Int = 2;
	static var PROP:Int = 3;


	public static function get(entry:String, validate = true):Story {
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


	static function parse(entry:String):Null<Page> {
		var string = normalize(entry);

		if (string.length == 0) return null;
		if (string.substring(0, 1) == "/") return null;

		var page = new Page();
		page.type = Page.TEXT;

		var leading = string.substring(0, 1);

		if (leading == "#") page.type = Page.ROUTE;
		if (leading == "-") page.type = getDialogue(string);
		if (leading == "[") page.type = getEvent(string);

		switch (page.type) {
			case Page.TEXT: setText(page, string);
			case Page.ROUTE: setRoute(page, string);
			case Page.DIALOGUE: setDialogue(page, string);
			case Page.EVENT: setEvent(page, string);
		}

		Syntax.custom(page, string);

		return page;
	}


	static function merge(page:Page, last:Page):Bool {
		if (page != null && page.type == Page.DIALOGUE && last != null && last.type == Page.DIALOGUE) {
			last.text = last.text + LINE + page.text;
			last.data = "dialogue";
			return true;
		}
		return false;
	}


	static function setText(page:Page, entry:String) {
		var raw = StringTools.replace(entry, ESCAPE, DIVIDE);
		var key = raw.indexOf(":");
	
		page.text = key >= 0 ? StringTools.trim(raw.substr(key + 1)) : raw;
		page.data = key >= 0 ? StringTools.trim(raw.substr(0, key)) : "";
		
		page.text = StringTools.replace(page.text, DIVIDE, KEY);

		var open = page.data.indexOf("<");
		var close = page.data.indexOf(">");

		if (open != -1 && close > open) {
			page.tags = page.data.substr(open + 1, close - open - 1);
			page.data = page.data.substr(0, open);
		}
	}


	static function setRoute(page:Page, entry:String) {
		var locked = entry.substring(0, 2) != HASH + HASH;

		page.text = StringTools.trim(StringTools.replace(entry, HASH, ""));
		page.data = locked ? "route" : "label";
	}


	static function setDialogue(page:Page, entry:String) {
		var segment = entry.substring(1).split(KEY);

		var text = StringTools.trim(segment.shift());
		var link = "empty";
		var data = "empty";
		var mode = "empty";
	
		for (field in segment) {
			var raw = StringTools.trim(field);
			if (raw == "") continue;
	
			var res = StringTools.replace(raw, SPACE, KEY);
			var key = res.split(KEY);

			if (key.length >= 3 && Logic.OPERATORS.contains(key[TEXT])) {
				data = res;
			}
			else if (key.length >= 3 && Logic.CONDITION.contains(key[TEXT])) {
				mode = res;
			}
			else {
				link = raw;
			}
		}

		page.text = text + ITEM + link + ITEM + data + ITEM + mode;
		page.data = "button";
	}


	static function setEvent(page:Page, entry:String) {
		var string = entry.substring(1, entry.length-1);

		string = StringTools.trim(string);
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
		if (Logic.OPERATORS.contains(key[TEXT])) {
			page.type = Page.VARIABLE;
			page.text = string;
		}
	}


	static function getDialogue(entry:String):String {
		if (entry.length >= 2 && entry.substring(0, 2) == DASH + DASH) return Page.BREAK;
		return Page.DIALOGUE;
	}


	static function getEvent(entry:String):String {
		if (entry.indexOf("]") != entry.length-1) return Page.TEXT;
		return Page.EVENT;
	}


	static function normalize(entry:String):String {
		return new EReg("\\s+", "g").replace(StringTools.trim(entry), SPACE);
	}
}