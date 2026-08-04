package harrow;

class Syntax {
	static final RESERVED = ["true", "false", "else", "end", "return", "chance", "roll"];

	// Custom syntax hook for user-defined parsing logic
	public static var custom:(Page, String) -> Void = customSyntax;

	// Default custom syntax handler (does nothing)
	static function customSyntax(page:Page, entry:String):Void {
	}


	// Syntax validation
	public static function validate(story:Story) {
		// Stores defined variables
		var variables:Map<String, Bool> = new Map();

		// Counts route name occurrences to detect duplicates
		var duplicates:Map<String, Int> = new Map();

		// Tracks routes and whether they are referenced
		var routes:Map<String, Bool> = new Map();

		// Collect definitions and statistics
		for (page in story.data) {
			// Register variable definitions
			if (page.type == Page.VARIABLE) {
				var segment = page.text.split(Library.KEY);

				var name = segment[0];
				var type = segment[1];

				if (type == "=" || type == "roll" || type == "chance") {
					if (!isValidName(name)) throw('Invalid variable name "${name}"');
					variables.set(name, true);
				}
			}

			// Register variable definitions made inside dialogue choices
			if (page.type == Page.DIALOGUE) {
				var lines = page.text.split(Library.LINE);
				for (line in lines) {
					var segment = line.split(Library.ITEM);
					if (segment.length < 4) continue;

					var data = segment[2];
					if (data == "empty") continue;

					var part = data.split(Library.KEY);
					var name = part[0];
					var type = part[1];

					if (type == "=" || type == "roll" || type == "chance") {
						if (!isValidName(name)) throw('Invalid variable name "${name}"');
						variables.set(name, true);
					}
				}
			}

			// Register declared routes
			if (page.type == Page.ROUTE && page.data == "route") {
				routes.set(page.text, false);
			}

			// Count route occurrences to detect duplicates
			if (page.type == Page.ROUTE) {
				var name = page.text;
				var count = duplicates.exists(name) ? duplicates.get(name) + 1 : 1;
				duplicates.set(name, count);
			}
		}

		// Validate references and syntax
		for (page in story.data) {
			switch (page.type) {
				// Validate move references to routes
				case Page.MOVE if (page.data == "move"): 
					if (routes.exists(page.text)) {
						routes.set(page.text, true);
					} else {
						trace('Warning: Reference to undefined route "${page.text}"');
					}

				// Validate route references inside dialogue lines
				case Page.DIALOGUE: 
					var lines = page.text.split(Library.LINE);
					for (line in lines) {
						var segment = line.split(Library.ITEM);
						
						var link = segment[1];
						var data = segment[2];
						var mode = segment[3];

						// Route reference
						if (link != "empty" && link != "return") {
							if (routes.exists(link)) {
								routes.set(link, true);
							} else {
								trace('Warning: Reference to undefined route "${link}" in dialogue choice');
							}
						}

						// Variable usage
						if (data != "empty") {
							var part = data.split(Library.KEY);
							var name = part[0];
							var type = part[1];

							if (type != "=" && type != "roll" && type != "chance" && !variables.exists(name)) {
								trace('Warning: Variable "${name}" is not defined (used in dialogue choice)');
							}
						}
					}

				// Validate condition syntax
				case Page.CONDITION if (page.data == "if"): 
					var part = page.text.split(Library.KEY);
					var type = part[1];

					if (part.length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					} 
					else if (!Logic.CONDITION.contains(type)) {
						trace('Warning: Unknown condition operator "${type}" in: "${page.text}"');
					}

				// Validate variable usage and arithmetic operations
				case Page.VARIABLE: 
					var part = page.text.split(Library.KEY);

					if (part.length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					}

					var name = part[0];
					var type = part[1];

					if (Logic.OPERATORS.contains(type)) {
						if (type != "=" && type != "roll" && type != "chance" && !variables.exists(name)) {
							trace('Warning: Variable "${name}" is not defined');
						}
					}

				default:
			}
		}

		// Report duplicate route definitions
		for (route => count in duplicates) {
			if (count > 1) trace('Warning: Duplicate route "${route}" (appears $count times)');
		}
		
		// Report routes that were never referenced
		for (route => reference in routes) {
			if (!reference) trace('Warning: Route "${route}" may be unreachable');
		}
	}


	static function isValidName(name:String):Bool {
		if (name == null || name.length == 0) return false;
		
		if (!Math.isNaN(Std.parseFloat(name))) return false;
		if (RESERVED.contains(name)) return false;

		var first = name.charAt(0);
		return (first >= "a" && first <= "z") || (first >= "A" && first <= "Z");
	}
}