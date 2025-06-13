package story;

import hxd.Key;

import harrow.Library;
import harrow.Runtime;
import harrow.Story;
import harrow.Choice;
import harrow.Page;

import heaps.Animate;


class Novel extends h2d.Object {
	public var runtime:Runtime;
	public var story:Story;

	public var width:Int = 640;
	public var height:Int = 128;

	var textbox:Textbox;
	var dialogue:Dialogue;

	var character:h2d.Bitmap;
	var frame:h2d.Bitmap;

	var state:String = "empty";

	
	public function new(entry:String) {
		super(null);

		story = Library.get(entry);
		runtime = new Runtime(story);

		runtime.onText = onText;
		runtime.onDialogue = onDialogue;

		frame = new h2d.Bitmap(h2d.Tile.fromColor(0xEEEEEE, width, height), this);

		character = new h2d.Bitmap(h2d.Tile.fromColor(0x585858, height-32, height-32), this);
		character.x = character.y = 16;
		character.visible = false;

		textbox = new Textbox(this);
		textbox.speed = 1.25;

		textbox.label.text = "Press [X]";
		textbox.label.x = width - 20;
		textbox.label.y = height - textbox.label.textHeight - 20;
		textbox.field.x = 30;
		textbox.field.y = 30;

		dialogue = new Dialogue(this);
		dialogue.visible = false;
	}


	public function next() {
		runtime.nextPage();
	}


	public function update(dt:Float) {
		if (state == "dialogue") {
			if (Key.isPressed(Key.UP) || Key.isPressed(Key.W)) {
				dialogue.order(-1);
			}
			if (Key.isPressed(Key.DOWN) || Key.isPressed(Key.S)) {
				dialogue.order(1);
			}

			if (Key.isPressed(Key.SPACE) || Key.isPressed(Key.X)) {
				state = "empty";
				onSelect(dialogue.selected.type, dialogue.selected.data);
			}
		}

		if (state == "text") {
			if (Key.isPressed(Key.SPACE) || Key.isPressed(Key.X)) {
				state = "empty";
				runtime.nextPage();
			}
		}
	}


	public function clear() {
		character.visible = false;
		textbox.label.text = "";
		textbox.field.text = "";
	}


	function onText(text:String, name:String) {
		textbox.label.visible = true;

		if (name != "") {
			character.visible = true;
			textbox.field.maxWidth = 480;
			textbox.field.x = 130;
		}
		else {
			character.visible = false;
			textbox.field.maxWidth = 580;
			textbox.field.x = 30;
		}

		textbox.label.text = "Press [X]";
		textbox.set(text);

		state = "text";
	}


	// Dialogue choices from `harrow.Runtime`
	function onDialogue(choices:Array<Choice>) {
		dialogue.set(choices);

		dialogue.x = width - dialogue.width;
		dialogue.y = -dialogue.height + 20;
		dialogue.visible = true;

		textbox.label.text = "Use [ARROWS] and [X]";

		state = "dialogue";
	}


	// Send selected choice data to `harrow.Runtime`
	function onSelect(type:String, data:String) {
		dialogue.visible = false;
		runtime.onChoice(type, data);
	}
}