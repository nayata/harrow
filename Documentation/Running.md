# Before start

Install the library from haxelib:

```haxe
haxelib install harrow
```

Alternatively the dev version of the library can be installed from github:

```haxe
haxelib git harrow https://github.com/nayata/harrow.git
```

Include the library in your project's `.hxml`:

```haxe
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


See a [Heaps](https://github.com/nayata/harrow/blob/main/example/src/App.hx) and [HTML](https://github.com/nayata/harrow-twine/blob/main/src/App.hx) example.



# Story

Instead of using a single large file, a story can be split across multiple files - for example, by chapters, quests, or locations.

This approach not only improves organization but also helps with route naming:
In a single file, all routes must have unique names, while in multiple files, common route names like `Init`, `Start`, or `Exit` can be safely reused.

To load a specific part of the story during runtime, use the [action](https://github.com/nayata/harrow/blob/main/Documentation/Writing.md#actions):

```
[story storyName]
```

This triggers the `onStory(name)` function in the runtime.
Connect a custom handler to `onStory` to load and play the corresponding story segment within the current runtime.

```haxe
novel.onStory = onStory;
```


```haxe
function onStory(name:String) {
	var entry = sys.io.File.getContent("res/" + name + ".txt");
		
	story = Library.get(entry);
	novel.story = story;

	novel.nextPage();
}
```

...

Actions

Page

Storage

Random

Events

Transition

Close

Format

See [Twine as editor](Twine.md) for more information.