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



# Page

The `onPage(page)` function is called by the runtime at the **very beginning** of each page flow - before any other events such as `onText`, `onChoice`, or actions.

It can be used for custom page-level processing or to override default behavior.

For example, it can be used to implement custom formatting for variables in the page text — since variable substitution is handled later during the `onText` call.

### Example:

```haxe
novel.onPage = onPage;
```


```haxe
function onPage(page:Page) {
	switch (page.type) {
		case Page.TEXT : 
			button.visible = true;
			var text = format(page.text);
			textbox.text = text;
		default:
	}
}
```

```haxe
function format(entry:String):String {
	var rex:EReg = ~/\[(.*?)\]/gi;

	entry = rex.map(entry, function(r) {
		var matching = r.matched(0);
		var variable = matching.substring(1, matching.length-1);

		if (harrow.Storage.has(variable)) return "[[" + harrow.Storage.get(variable) + "]]";
		return matching;
	});

	return entry;
}
```



# Events

Events provide a simple syntax for executing external logic during the story flow. They allow integration of visual updates, sound playback, or game-specific systems without modifying the runtime.

To define a custom event in a story, use square brackets - avoiding reserved keywords used for **actions**, **conditions**, or **variables**.

When an event is encountered, the runtime calls:

```haxe
onEvent(type, data)
```

* `type` - the part of the event before the first space
* `data` - the remaining content after the first space

> **Important:** All spaces in `data` are replaced with the separator `:`.

If the event contains only two parts `[textbox show]`, `data` can be used directly.
For events with more parts `[button property x 64]`, the `data` string should be split into an array using `harrow.Format`.

### Example:

```haxe
import harrow.Format;

...

novel.onEvent = onEvent;
```

```haxe
function onEvent(type:String, data:String) {
	switch (type) {
		case "textbox": 
			if (data == "show") textbox.visible = true;
			if (data == "hide") textbox.visible = false;

		case "button": 
			var map = Format.from(data);
			var key = map.shift();

			var name = map[0];
			var prop = map[1];

			if (key == "property") Reflect.setProperty(button, name, Std.parseFloat(prop));
			if (key == "text") button.text = Format.string(Format.to(map));

		default:
	}
}
```

`onEvent` can act as a hub, routing data to the appropriate class. See `App.hx` and `Prefab.hx` in [examples](https://github.com/nayata/harrow/tree/main/example).

Events automatically advance the flow to the next page after execution.

See [Twine](Twine.md) for more information.