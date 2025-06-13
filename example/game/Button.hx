class Button extends h2d.Object {
	var input:h2d.Interactive;
	var image:h2d.Bitmap;
	var label:h2d.Text;
	
	public var selected:Bool = false;

	public var text(default, set):String = "empty"; 
	public var mode(default, set):String = "empty"; 

	public var type:String = "";
	public var data:String = "";
	public var role:String = "";

	public var width:Int = 256;
	public var height:Int = 64;

	
	public function new(?parent:h2d.Object) {
		super(parent);

		input = new h2d.Interactive(width, height, this); 
		input.onClick = function(e:hxd.Event) { 
			selected = true;
			onClick(); 
		};

		image = new h2d.Bitmap(h2d.Tile.fromColor(0x222222, width, height), this);

		label = new h2d.Text(hxd.Res.libreDefault.toFont(), this);
		label.textAlign = h2d.Text.Align.Center;
		label.textColor = 0xFFFFFF;

		label.x = width * 0.5;
		label.y = height * 0.5 - label.textHeight * 0.5;
	}


	public dynamic function onClick() {}


	function set_text(v) {
		return text = label.text = v;
	}


	function set_mode(v) {
		mode = v;

		switch (mode) {
			case "button" :
				input.visible = true;
				label.textColor = 0xFFFFFF;
				image.tile = h2d.Tile.fromColor(0x555555, width, height);
				image.alpha = 1.0;
			case "choice" :
				input.visible = true;
				image.tile = h2d.Tile.fromColor(0x999999, width, height);
				label.textAlign = h2d.Text.Align.Left;
				label.textColor = 0xFFFFFF;
				label.x = 32;
				image.alpha = 1.0;
			case "selected" :
				label.textColor = 0xCE003E;
			case "disabled":
				input.visible = false;
				label.textColor = 0x999999;
				image.alpha = 0.8;
			default:
		}
		
		return mode;
	}
}