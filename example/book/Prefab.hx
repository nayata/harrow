class Prefab extends h2d.Object {
	var bitmap:h2d.Bitmap;

	
	public function event(entry:String) {
		var data = harrow.Format.from(entry);
		var type = data.shift();

		var name = data[0];
		var prop = data[1];

		switch (type) {
			case "show": 
				visible = true;
			case "hide": 
				visible = false;

			case "prop": 
				Reflect.setProperty(this, name, Std.parseFloat(prop));
			case "property": 
				Reflect.setProperty(this, name, Std.parseFloat(prop));

			case "image": 
				if (!hxd.res.Loader.currentInstance.exists(name)) throw("Could not find image " + name);

				if (bitmap == null) bitmap = new h2d.Bitmap(this);
				bitmap.tile = hxd.Res.load(name).toImage().toTile();

			case "remove":
				App.ME.unregister(this);
			default:
		}
	}


	public function update(dt:Float) {
	}
}