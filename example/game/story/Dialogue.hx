package story;

class Dialogue extends h2d.Object {
	public var width:Float = 1280;
	public var height:Float = 720;

	public var selected:Button = null;

	var view:h2d.Object;
	var choices:Array<Button> = [];

	var displayed:Int = 0;
	var index:Int = 0;

	var maximum:Int = 6;
	var spacing:Int = 4;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		// Container for choices + choices pool
		view = new h2d.Object(this);
		for (i in 0...maximum) {
			var choice = new Button(view);
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

			choices[i].mode = "choice";

			choices[i].y = i * (choices[i].height + spacing);
			choices[i].visible = true;
		}

		displayed = dialogue.length - 1;
		index = 0;

		choices[index].mode = "selected";
		selected = choices[index];
		
		onResize();
	}


	// Select choice
	public function order(position:Int) {
		choices[index].mode = "choice";

		index = index + position;
		
		if (index > displayed) index = displayed;
		if (index < 0) index = 0;

		choices[index].mode = "selected";
		selected = choices[index];
	}


	// Dialogue container size
	public function onResize() {
		var bound = view.getBounds();

		width = bound.width;
		height = bound.height;
	}
}