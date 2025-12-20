import harrow.Library;
import harrow.Runtime;
import harrow.Story;
import harrow.Choice;
import harrow.Page;

import harrow.twine.Parser;


class App extends hxd.App {
	public static var ME:App;

	public var width:Int = 1280;
	public var height:Int = 720;

	var novel:Runtime;
	var story:Story;

	var textbox:h2d.Text;
	var dialogue:Dialogue; 
	var button:Button;

	var hierarchy:Map<String, Prefab> = new Map();
	var scene:Prefab;

	var buffer:String = "";
	var maxlenght:Int = 124;


	static function main() {
		ME = new App();
	}


	override function init() {
		engine.backgroundColor = 0xFFFFFF;
		hxd.Res.initLocal();

		// Set custom random to `Logic.random`
		var dice = new Dice();
		harrow.Random.dice = dice.roll;

		// Don't parse speaker(name: text from character)
		Library.parseSpeaker = false;

		var entry = sys.io.File.getContent("res/story.twee");

		// Instead of `harrow.Library` the `harrow.twine.Parser` used here to load `.twee` files
		story = Parser.get(entry);
		novel = new Runtime(story);

		// `harrow.Runtime` story events: text, choices, commands, load next story, story is ended
		novel.onText = onText;
		novel.onDialogue = onDialogue;
		novel.onEvent = onEvent;
		novel.onStory = onStory;
		novel.onEnd = onEnd;

		// Container for visuals
		scene = new Prefab(s2d); 

		// UI elements: textbox, continue button and choices dialogbox
		textbox = new h2d.Text(hxd.Res.libreDefault.toFont(), s2d);
		textbox.x = 710;
		textbox.y = 140;
		textbox.textColor = 0x1B1B1B;
		textbox.lineSpacing = 8;
		textbox.maxWidth = 360;

		button = new Button(s2d); 
		button.x = 670; button.y = 560;
		button.onClick = onClick;
		button.text = "Continue";
		button.visible = false;

		dialogue = new Dialogue(s2d);
		dialogue.x = 670;
		dialogue.onSelect = onSelect;
		dialogue.visible = false;

		// Start story
		novel.nextPage();
	}


	// `Continue` button event
	function onClick() {
		button.visible = false;
		novel.nextPage();
	}


	// Show text accumulated in buffer
	function showText() {
		textbox.text = buffer;
		buffer = "";
	}


	// Text event from `harrow.Runtime`
	// Here text is accumulated in buffer and showed based on 'buffer' lenght, instead of simply showing text.
	function onText(text:String, name:String) {
		buffer = buffer + text + "\n\n";

		var ready = buffer.length > maxlenght;
		var page = novel.story.look(novel.story.page + 1);
		var last = page == null;

		if (last) {
			button.visible = true;
			showText();
		}

		if (last) return;

		if (page.type == Page.DIALOGUE && ready) {
			novel.nextPage();
		}
		if (page.type != Page.DIALOGUE && ready) {
			button.visible = true;
			showText();
		}

		if (ready) return;

		if (page.type == Page.TEXT || page.type == Page.DIALOGUE) {
			novel.nextPage();
		}
		else {
			button.visible = true;
			showText();
		}
	}


	// Dialogue choices from `harrow.Runtime`
	function onDialogue(choices:Array<Choice>) {
		if (buffer.length > 0) showText();

		dialogue.set(choices);
		dialogue.visible = true;
		button.visible = false;
	}


	// Send selected choice data to `harrow.Runtime`
	function onSelect(type:String, data:String) {
		dialogue.visible = false;
		novel.onChoice(type, data);
	}


	// Main `event` system: filter functions by type and send remaining to prefab as `prefab.event(data);`
	function onEvent(type:String, data:String) {
		switch (type) {
			case "textbox": 
			case "dialogue": 
			case "button": 

			case "add":
				var prefab = new Prefab(scene);
				prefab.name = data;
				register(prefab);

			default:
				if (hierarchy.exists(type)) {
					hierarchy.get(type).event(data);
				}
		}
	}


	// Load new story
	function onStory(name:String) {
		var entry = sys.io.File.getContent("res/" + name + ".twee");
		story = Parser.get(entry);
		novel.story = story;
		
		novel.nextPage();
	}


	// harrow.Runtime events
	function onPage(page:Page) {}
	function onTransition(name:String) {}
	function onClose() {}
	function onEnd() {}


	// Add 'Prefab' object to hierarchy
	public function register(prefab:Prefab) {
		if (hierarchy.exists(prefab.name)) throw(prefab.name + " is alredy exist.");
		hierarchy.set(prefab.name, prefab);
	}


	// Remove 'Prefab' object from hierarchy and from scene
	public function unregister(prefab:Prefab) {
		if (hierarchy.exists(prefab.name)) {
			hierarchy.remove(prefab.name);
			prefab.remove();
		}
	}


	// Update all prefabs in hierarchy
	override function update(dt:Float) {
		super.update(dt);
		
		for (prefab in hierarchy) {
			prefab.update(dt);
		}
	}


	override function onResize() {
		super.onResize();

		width = hxd.Window.getInstance().width;
		height = hxd.Window.getInstance().height;
	}
}