class Textbox extends h2d.Object {
	var string:String = "";

	public var done:Bool = false;
	public var speed:Float = 1.5;

	var progress:Float = 0;
	var step:Float = 0;
	
	var label:h2d.Text;
	var field:h2d.Text;

	
	public function new(?parent:h2d.Object) {
		super(parent);

		label = new h2d.Text(hxd.Res.libreDefault.toFont(), this);
		label.textColor = 0x532C2C;

		field = new h2d.Text(hxd.Res.libreDefault.toFont(), this);
		field.textColor = 0x1B1B1B;
		field.maxWidth = 800;
		field.y = 40;
	}


	public function set(text:String, name:String) {
		label.text = name;

		string = field.splitText(text);
		
		step = speed / string.length;
		progress = 0;
		done = false;
	}


	public function fill() {
		field.text = string;
		done = true;
	}


	public function clear() {
		field.text = label.text = "";
	}


	override function sync(ctx:h2d.RenderContext) {
		super.sync(ctx);

		if (done) return;
		if (progress >= 1) done = true;

		field.text = field.getTextProgress(string, progress * string.length);
		progress += step;
	}
}