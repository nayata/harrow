import harrow.Library;
import harrow.Runtime;
import harrow.Story;
import harrow.Page;

import heaps.Animate;
import heaps.Scene;

import story.Novel;


class App extends hxd.App {
	public static var ME:App;

	public var width:Int = 1280;
	public var height:Int = 720;

	public var tween:Animate;
	public var scene(default, set):Scene;
	public var novel:Novel;


	static function main() {
		ME = new App();
	}


	override function init() {
		engine.backgroundColor = 0xFFFFFF;
		hxd.Res.initLocal();

		tween = new Animate(hxd.Timer.wantedFPS);

		var entry = sys.io.File.getContent("res/game.txt");
		novel = new Novel(entry);

		scene = new Title();
	}


	function set_scene(entry:Scene) {
		sevents.checkEvents();

		if (scene != null) scene.remove();
		scene = entry;
		s2d.add(scene);
		
		return scene;
	}


	// Update tween and scene
	override function update(dt:Float) {
		super.update(dt);
		tween.update(dt);
		scene.update(dt);
	}


	override function onResize() {
		super.onResize();

		width = hxd.Window.getInstance().width;
		height = hxd.Window.getInstance().height;
	}
}