package harrow;

class Syntax {
	public static function validate(story:Story) {
		var routes:Map<String, Bool> = new Map();

		for (page in story.data) {
			if (page.type == Page.ROUTE && page.data == "route") {
				routes.set(page.text, false);
			}
		}

		for (page in story.data) {
			switch (page.type) {
				case Page.MOVE if (page.data == "move"): 
					if (routes.exists(page.text)) {
						routes.set(page.text, true);
					} else {
						trace('Warning: Reference to undefined route "${page.text}"');
					}

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

				case Page.CONDITION if (page.data == "if"): 
					if (page.text.split(Library.KEY).length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					}

				case Page.VARIABLE: 
					if (page.text.split(Library.KEY).length < 3) {
						trace('Warning: Invalid input format: "${page.text}". Expected: name:operator:value');
					}

				default:
			}
		}
		
		for (route => reference in routes) {
			if (!reference) trace('Warning: Route "${route}" may be unreachable');
		}
	}
}