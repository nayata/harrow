class Title extends heaps.Scene {
	var button:Button;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		button = new Button(this); 
		button.x = 640 - button.width * 0.5; 
		button.y = 360 - button.height * 0.5; 
		button.onClick = onClick;
		button.mode = "button";
		button.text = "PLAY";
	}


	function onClick() {
		app.scene = new Game();
	}
}