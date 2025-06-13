package entity;

import h2d.col.Point;
import hxd.Key;

class Player extends h2d.Object {
	var bitmap:h2d.Bitmap;
	var direction = new Point(0, 0);
	var speed:Float = 8;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bitmap = new h2d.Bitmap(hxd.Res.battle.toTile(), this);
		bitmap.tile.setCenterRatio();
		bitmap.smooth = true;
		bitmap.y = -256;

		scale(0.2);
	}


	public function update(dt:Float) {
		direction.x = direction.y = 0;

		if (Key.isDown(Key.UP) || Key.isDown(Key.W)) { direction.y = -1; }
		if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) { direction.y = 1; }
		if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) {
			App.ME.tween.add(bitmap.scaleX, -1, 1);
			direction.x = -1; 
			
		}
		if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) { 
			App.ME.tween.add(bitmap.scaleX, 1, 1);
			direction.x = 1; 
		}

		direction.normalize();
		direction.scale(speed);

		x += direction.x;
		y += direction.y;
	}
}