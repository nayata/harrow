# Before start

Install the library from haxelib:

```
haxelib install harrow
```

Alternatively the dev version of the library can be installed from github:

```
haxelib git harrow https://github.com/nayata/harrow.git
```

Include the library in your project's `.hxml`:

```
-lib harrow
```



# Runtime

To execute a story in Harrow:

1. Load and parse the story file into a `harrow.Story` object using `harrow.Library`.

2. Create a `harrow.Runtime` instance and pass the `Story` to it.

3. Start the story flow by calling the `novel.nextPage()` function.

### Example (using Heaps):

```haxe
import harrow.Library;
import harrow.Runtime;
import harrow.Story;

class App extends hxd.App {
	var novel:Runtime;
	var story:Story;

	override function init() {
		hxd.Res.initLocal();
		
		var entry = sys.io.File.getContent("res/story.txt");
		
		story = Library.get(entry);
		novel = new Runtime(story);

		novel.nextPage(); 
	}

	static function main() { 
		new App(); 
	}
}
```



# Text

To display text from a Harrow story:

1. Create a text field or output area in your UI.
2. Define a function that renders text content to that field.
3. Assign this function to `onText(text, name)` in the `harrow.Runtime` instance.

The `text` parameter contains the line to display, and `name` contains the speaker’s name if it is a line of dialogue.

### Example:

```haxe
class App extends hxd.App {
	var novel:Runtime;
	var story:Story;

	var label:h2d.Text;
	var field:h2d.Text;

	override function init() {
		hxd.Res.initLocal();
		
		var entry = sys.io.File.getContent("res/story.txt");
		
		story = Library.get(entry);
		novel = new Runtime(story);
		
		novel.onText = onText;

		label = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		label.textColor = 0xFFE600;

		field = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		field.textColor = 0xDDDDDD;
		field.y = 32;

		novel.nextPage(); 
	}

	function onText(text:String, name:String) {
		label.text = name;
		field.text = text;
	}

	static function main() { 
		new App(); 
	}
}
```



# Flow handling

**Harrow** uses a flow-based execution model, unlike systems such as **Twine**, which display the entire content of a passage at once. In Harrow, content is revealed step-by-step, following the flow of the story.

Depending on the page type, the flow may automatically continue to the next page or pause, waiting for an external command to proceed.

`Text` is one of the cases where user input is required to continue the story flow. 

This can be done through UI interaction (e.g. clicking a "continue" button) or via keyboard events (e.g. pressing a key). This ensures the story only progresses when the user is ready.

### Example (using button):

...

See [Twine as editor](Twine.md) for more information.