package harrow.twine;

// Based on https://github.com/videlais/extwee
class Parser {
	public static function get(entry:String):Story {
		var story = new Story();
		var start = "";


		// Split the file based on the passage sigil (::) proceeded by a newline
		var passages = entry.split("\n::");

		// Fix the first result
		passages[0] = passages[0].substring(2, passages[0].length);


		// Iterate through the passages
		for (passage in passages) {
			// Header is everything to the first newline
			var header = passage.substring(0, passage.indexOf('\n'));

			// Text is everything else
			var text = passage.substring(header.length + 1, passage.length);
			text = StringTools.trim(text);

			// Remove the metadata from the header
			var openingCurlyBracketPosition = header.lastIndexOf('{');
			var closingCurlyBracketPosition = header.lastIndexOf('}');
		
			if (openingCurlyBracketPosition != -1 && closingCurlyBracketPosition != -1) {
			  header = header.substring(0, openingCurlyBracketPosition) + header.substring(closingCurlyBracketPosition + 1);
			  header = StringTools.trim(header);
			}

			// Remove tags
			var openingSquareBracketPosition = header.lastIndexOf('[');
			var closingSquareBracketPosition = header.lastIndexOf(']');
			
			if (openingSquareBracketPosition != -1 && closingSquareBracketPosition != -1) {
				header = header.substring(0, openingSquareBracketPosition) + header.substring(closingSquareBracketPosition + 1);
				header = StringTools.trim(header);
			}

			// Trim any remaining whitespace
			header = StringTools.trim(header);

			// Check if there is a name left
			if (header.length == 0) throw('Malformed passage header!');

			// Parse StoryData for startnode.
			if (header == 'StoryData') {
				var metadata = haxe.Json.parse(text);
				start = metadata.start;
				continue;
			}

			// Parse StoryTitle.
			if (header == 'StoryTitle') {
				story.name = text;
				continue;
			}

			// Skip css and js
			if (header == 'StoryStylesheet' || header == 'StoryScript') {
				continue;
			}

			// This is not StoryData or StoryTitle.

			// Add Route from Passage name
			var route = new Page();
			route.type = Page.ROUTE;
			route.text = header;

			story.data.push(route);
			
			// Parse Passage
			var res = text.split(Library.LF);

			// Replace Twine links
			for (i in 0...res.length) {
				var string = StringTools.trim(res[i]);
				
				var lead = string.substring(0, 1);
				var link = string.substring(0, 2);

				if (lead == "-") {
					string = StringTools.replace(string, "[[", "");
					string = StringTools.replace(string, "]]", "");
				}
				if (link == "[[") {
					string = StringTools.replace(string, "[[", "");
					string = StringTools.replace(string, "]]", "");
					string = "[move " + string + "]";
				}

				res[i] = string;
			}

			// Parse Passage content
			var line:Int = 0;
	
			while (line < res.length) {
				var node = Library.getNode(res, line);
				
				if (node != null && node.type != Library.EMPTY) {
					var page = new Page();
	
					page.type = node.type;
					page.text = node.text;
					page.data = node.data;
	
					story.data.push(page);
	
					line += node.depth;
				}
				line++;
			}
		}
		
		
		// Move 'Story.page' to StoryData 'start' value
		story.move(start);

		// Return harrow.Story.
		return story;
	}

}