package harrow;

class Syntax {
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
				var parts = page.text.split(Library.KEY);

				var name = parts[0];
				var type = parts[1];

				if (type == "=" || type == "roll" || type == "chance") {
					variables.set(name, true);
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
						var parts = line.split(Library.ITEM);
						if (parts.length >= 3 && parts[1] == "route") {
							var target = parts[2];
	
							if (routes.exists(target)) {
								routes.set(target, true);
							} else {
								trace('Warning: Reference to undefined route "${target}"');
							}
						}
					}

				// Validate condition syntax
				case Page.CONDITION if (page.data == "if"): 
					if (page.text.split(Library.KEY).length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					}

				// Validate variable usage and arithmetic operations
				case Page.VARIABLE: 
					var parts = page.text.split(Library.KEY);

					if (parts.length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					}

					// Check usage of undefined variables in operations
					var name = parts[0];
					var type = parts[1];
	
					if (type == "+" || type == "-" || type == "*" || type == "/") {
						if (!variables.exists(name)) {
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
}