package harrow;

class Runtime {
	public var story:Story;
	public var page:Page;


	public function new(entry:Story) {
		story = entry;
	}

	
	public function nextPage() {
		if (story.end) onEnd();
		if (story.end) return;

		page = story.next();
		onPage(page);
		
		switch (page.type) {
			case Page.TEXT : 
				var text = Format.variable(page.text);
				onText(text, page.data);
			case Page.DIALOGUE : 
				var dialogue = Dialogue.get(page.text);
				for (choice in dialogue) {
					choice.text = Format.variable(choice.text);
				}
				onDialogue(dialogue);
			
			case Page.ROUTE : 
			case Page.BREAK : nextPage();
			
			case Page.MOVE : 
				if (page.data == "story") onStory(page.text);
				if (page.data == "close") onClose();
				if (page.data == "move") {
					story.move(page.text);
					nextPage();
				}
				
			case Page.CONDITION : 
				var condition = Logic.condition(page.text);
				if (condition == false) story.skip();
				nextPage();
			case Page.VARIABLE : 
				Logic.variable(page.text);
				nextPage();

			case Page.EVENT : 
				gameEvent();
			default:
		}
	}


	function gameEvent() {
		switch (page.data) {
			case "wait":
				var time = Std.parseInt(page.text);
				haxe.Timer.delay(nextPage, time * 60);
			case "transition":
				onTransition();
			case "scene":
				onEvent(page.data, page.text);
			default:
				onEvent(page.data, page.text);
				nextPage();
		}
	}


	public function onChoice(type:String, data:String) {
		if (type == "route") story.move(data);
		if (type == "variable") Logic.variable(data);
		nextPage();
	}

	public dynamic function onPage(page:Page) {}

	public dynamic function onText(text:String, name:String) {}
	public dynamic function onDialogue(dialogue:Array<Choice>) {}
	public dynamic function onEvent(type:String, data:String) {}

	public dynamic function onTransition() {}

	public dynamic function onStory(name:String) {}
	public dynamic function onClose() {}
	public dynamic function onEnd() {}
}