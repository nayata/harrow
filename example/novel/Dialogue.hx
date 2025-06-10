class Dialogue extends h2d.Object {
	var view:h2d.Object;

	var choices:Array<Button> = [];
	var selected:Bool = false;

	var maximum:Int = 6;
	var spacing:Int = 4;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		// Container for choices + choices pool
		view = new h2d.Object(this);
		for (i in 0...maximum) {
			var choice = new Button(view);
			choice.onClick = onClick;
			choice.mode = "choice";
			choices.push(choice);
		}
	}


	// Set and show button choices using data from `dialogue` array
	public function set(dialogue:Array<harrow.Choice>) {
		for (choice in choices) {
			choice.visible = false;
		}

		for (i in 0...dialogue.length) {
			choices[i].text = (i+1) + ". " + dialogue[i].text;
			choices[i].type = dialogue[i].type;
			choices[i].data = dialogue[i].data;
			
			choices[i].visible = true;
			choices[i].y = i * (choices[i].height + spacing);
		}

		selected = false;
		onResize();
	}


	// Choices `onClick` event: make a clicked to be `selected`
	function onClick() {
		for (choice in choices) {
			if (choice.selected) {
				onSelect(choice.type, choice.data);
				choice.selected = false;
			}
		}
	}


	public dynamic function onSelect(type:String, data:String) {
	}


	// Align dialogue container to the center of the screen
	public function onResize() {
		var bound = view.getBounds();
		view.x = App.ME.width * 0.5 - bound.width * 0.5;
		view.y = App.ME.height * 0.5 - bound.height * 0.5;
	}
}