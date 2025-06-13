import entity.Player;
import entity.Triger;

import story.Novel;


class Game extends heaps.Scene {
	var button:Button;

	var state:String = "empty";

	var world:Array<Triger> = [];
	var player:Player;
	var novel:Novel;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		button = new Button(this); 
		button.x = 1280 - button.width - 20; 
		button.y = 20; 
		button.onClick = onClick;
		button.mode = "button";
		button.text = "TITLE";

		// NPC
		var triger = new Triger(this);
		triger.route = "NPC";
		triger.type = "character";
		triger.onEnter = onEnter;
		triger.onExit = onExit;
		triger.x = 124; 
		triger.y = 300;
		world.push(triger);

		// Item
		triger = new Triger(this);
		triger.route = "Item";
		triger.type = "item";
		triger.onEnter = onEnter;
		triger.onExit = onExit;
		triger.x = 640; 
		triger.y = 124;
		world.push(triger);

		// Boss
		triger = new Triger(this);
		triger.route = "Boss";
		triger.type = "enemy";
		triger.onEnter = onEnter;
		triger.onExit = onExit;
		triger.x = 1156; 
		triger.y = 300;
		world.push(triger);


		// Player
		player = new Player(this); 
		player.x = 1280 * 0.5;
		player.y = 920 * 0.5;


		// Atach player to trigers as target
		for (triger in world) {
			triger.target = player;
		}
		
		// Novel container
		novel = App.ME.novel;
		novel.runtime.onClose = hide;
		add(novel);

		novel.alpha = 0;
		novel.x = 1280 * 0.5 - novel.width * 0.5;
		novel.y = 720 + novel.height;

		// Move to the first route and start story with delayed `show()`;
		novel.story.move("Start");
		App.ME.tween.call(show, 3);
	}


	function show() {
		App.ME.tween.add(novel.alpha, 1, 3);
		App.ME.tween.add(novel.y, 720 - novel.height - 20, 3);

		App.ME.tween.call(novel.next, 3);// Delayed novel.next();
		novel.clear();

		state = "text";
	}


	function hide() {
		App.ME.tween.add(novel.alpha, 0, 3);
		App.ME.tween.add(novel.y, 720 + novel.height, 3);

		state = "game";
	}


	override public function update(dt:Float) {
		if (state == "game") player.update(dt);
		if (state == "text") novel.update(dt);

		for (triger in world) {
			triger.update(dt);
		}
	}


	function onEnter(triger:Triger) {
		novel.story.move(triger.route);
		show();
	}

	function onExit(triger:Triger) {
		hide();
	}


	function onClick() {
		app.scene = new Title();
	}
}