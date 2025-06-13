package entity;

class Triger extends h2d.Object {
	public var target:h2d.Object;

	public var route = "";
	public var type = "";

	var collide = false;
	var active = false;

	var size:Int = 100;


	public function new(?parent:h2d.Object) {
		super(parent);

		var frame = new h2d.Bitmap(h2d.Tile.fromColor(0xEEEEEE, size*2, size*2), this);
		frame.tile.setCenterRatio();
	}

	public function update(dt:Float) {
		if (target == null) return;

		collide = intersect();

		if (!active && collide) {
			active = true;
			onEnter(this);
		}

		if (active && !collide) {
			active = false;
			onExit(this);
		}
	}

	function intersect():Bool {
		return(target.x <= x+size) && (target.x >= x-size) && (target.y <= y+size) && (target.y >= y-size);
	}

	public dynamic function onEnter(triger:Triger) {
	}

	public dynamic function onExit(triger:Triger) {
	}
}