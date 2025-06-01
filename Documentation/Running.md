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

To run a story in Harrow:

1. Load and parse the story file into a `harrow.Story` object using `harrow.Library`.

2. Create a `harrow.Runtime` instance and pass the `Story` to it.

3. Assign your own functions—such as `onText`, `onDialogue`, and others—to the `harrow.Runtime` to define how the runtime interacts with your UI or systems.

4. Start the story flow by calling the `novel.nextPage()` function.

### Example (using Heaps):

```haxe
import harrow.Library;
import harrow.Runtime;
import harrow.Story;
import harrow.Choice;

class App extends hxd.App {
	var novel:Runtime;
	var story:Story;

	override function init() {
		hxd.Res.initLocal();
		
		var entry = sys.io.File.getContent("res/story.txt");
		
		story = Library.get(entry);
		novel = new Runtime(story);

		novel.onText = onText;
		novel.onDialogue = onDialogue;

		novel.nextPage(); 
	}

	function onText(text:String, name:String) {
		trace(name, text);
	}

	function onDialogue(choices:Array<Choice>) {
		for (choice in choices) {
			trace(choice.text);
		}
	}

	static function main() { 
		new App(); 
	}
}
```



# Flow handling

**Harrow** uses a flow-based execution model, unlike systems such as **Twine**, which display the entire content of a passage at once. In Harrow, content is revealed step-by-step, following the flow of the story.

Depending on the page type, the flow may automatically continue to the next page or pause, waiting for an external command to proceed.

`Text` and `Dialogue` are cases where **user input is required** to continue the story flow.

This can be handled through UI interactions or keyboard events. This ensures the story only progresses when the player is ready.

### Text

After displaying the text content, the runtime waits for continuation. Once input is received, call:

```haxe
novel.nextPage();
```

### Dialogue (Choices)

For choices, the runtime pauses and waits for choice input.
After the player selects an option, pass the choice information to the runtime:

```haxe
novel.onChoice(choice.type, choice.data);
```

...


Story

Page

Storage

Random

Events

Transition

Close

Format

See [Twine as editor](Twine.md) for more information.