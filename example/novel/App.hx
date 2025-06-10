import harrow.Library;
import harrow.Runtime;
import harrow.Story;
import harrow.Choice;
import harrow.Page;

import heaps.Animate;


class App extends hxd.App {
	public static var ME:App;

	public var width:Int = 1280;
	public var height:Int = 720;

	public var tween:heaps.Animate;

	var novel:Runtime;
	var story:Story;

	var textbox:Textbox;
	var dialogue:Dialogue; 
	var button:Button;

	var hierarchy:Map<String, Prefab> = new Map();
	var transition:h2d.Bitmap;
	var scene:Prefab;


	static function main() {
		ME = new App();
	}


	override function init() {
		engine.backgroundColor = 0xFFFFFF;
		hxd.Res.initLocal();

		// Tween
		tween = new Animate(hxd.Timer.wantedFPS);

		var entry = sys.io.File.getContent("res/story.txt");
		
		story = Library.get(entry);
		novel = new Runtime(story);

		novel.onText = onText;
		novel.onDialogue = onDialogue;
		novel.onTransition = onTransition;
		novel.onEvent = onEvent;
		novel.onEnd = onEnd;

		// Container for visuals
		scene = new Prefab(s2d); 

		// Elements: textbox, button and choices
		textbox = new Textbox(s2d);
		textbox.speed = 1.25;
		textbox.x = 264;
		textbox.y = 480;

		button = new Button(s2d); 
		button.x = 264; button.y = 640;
		button.onClick = onClick;
		button.mode = "button";
		button.text = "Continue";
		button.visible = false;

		dialogue = new Dialogue(s2d);
		dialogue.onSelect = onSelect;
		dialogue.visible = false;

		// Transition bitmap
		transition = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, width, height), s2d);
		transition.alpha = 0;

		// Start story
		novel.nextPage();
	}


	// `Continue` button event
	function onClick() {
		if (textbox.done) {
			button.visible = false;
			novel.nextPage();
		}
		else {
			textbox.fill();
		} 
	}


	// Text event from `harrow.Runtime`
	function onText(text:String, name:String) {
		textbox.set(text, name);
		button.visible = true;
	}


	// Dialogue choices from `harrow.Runtime`
	function onDialogue(choices:Array<Choice>) {
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
				if (data == "show") textbox.visible = true;
				if (data == "hide") textbox.visible = false;
				if (data == "clear") textbox.clear();

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
		var entry = sys.io.File.getContent("res/" + name + ".txt");
		story = Library.get(entry);

		novel.story = story;
		novel.nextPage();
	}


	// Transition
	function onTransition() {
		function fade() {
			tween.add(transition.alpha, 0, 6, 6);
			tween.call(novel.nextPage, 6);
		}
		tween.add(transition.alpha, 1, 6).end(fade);
	}


	// harrow.Runtime events
	function onPage(page:Page) {}
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


	// Update tween and all prefabs in hierarchy
	override function update(dt:Float) {
		super.update(dt);
		tween.update(dt);
		
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