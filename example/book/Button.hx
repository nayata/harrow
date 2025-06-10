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

	public var width:Int = 420;
	public var height:Int = 50;

	
	public function new(?parent:h2d.Object) {
		super(parent);

		input = new h2d.Interactive(width, height, this); 
		input.onOver = onOver;
		input.onOut = onOut;

		input.onClick = function(e:hxd.Event) { 
			selected = true;
			onClick(); 
		};

		image = new h2d.Bitmap(h2d.Tile.fromColor(0x2B2B2B, width, height), this);
		image.alpha = 0.0;

		label = new h2d.Text(hxd.Res.libreDefault.toFont(), this);
		label.textAlign = h2d.Text.Align.Center;
		label.textColor = 0x1D1D1D;

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
			case "choice":
				input.visible = true;
				label.textAlign = h2d.Text.Align.Left;
				label.x = 80;
			case "disabled":
				input.visible = false;
				label.textColor = 0x999999;
			default:
				input.visible = true;
				label.textAlign = h2d.Text.Align.Center;
				label.x = width * 0.5;
		}
		
		return mode;
	}


	function onOver(e:hxd.Event) {
		label.alpha = 0.95;
	}


	function onOut(e:hxd.Event) {
		label.alpha = 1;
	}
}