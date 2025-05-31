# Introduction

**Harrow** uses a flow-based execution model, unlike systems such as **Twine**, which display the entire content of a passage at once. In Harrow, content is revealed step-by-step, following the flow of the story.

Depending on the page type, the flow may automatically continue to the next page or pause, waiting for an external command to proceed.


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

### Example

```
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
...

See [Twine as editor](Twine.md) for more information.