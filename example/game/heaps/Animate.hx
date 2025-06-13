package heaps;

import haxe.macro.Expr;


class Animate {
	var animate:Array<Tween> = [];
	var process:Array<Trait> = [];
	var fps:Float = 60;


	public function new(baseFps:Float) {
		fps = baseFps;
	}


	/**
		Add a tween to animate a specific property of a target object over time.
		@param target The object whose property you want to animate.
		@param property The name of the property to animate on the target object.
		@param to The final value the property should animate to.
		@param time Duration of the tween.
		@param easing (Optional) Easing function to control the animation curve. See `heaps.Easing` for available options.
		@param delay (Optional) Delay before the tween starts.
	*/
	public function set(target:Dynamic, property:String, to:Float, time:Float, ?easing:String = "linear", ?delay:Float = 0):Tween {
		var tween = new Tween();

		tween.target = target;
		tween.ease = heaps.Easing.get(easing);

		tween.time = 0;
		tween.step = 0;
		tween.speed = 1 / (time*fps/1000);
		tween.delay = delay * fps/1000;

		tween.autoclear = false;
		tween.done = false;
		
		tween.setter = property;
		tween.from = Reflect.field(target, property);
		tween.to = to;

		if (delay == 0) terminate(tween.target, tween.setter);

		animate.push(tween);

		return tween;
	}

	
	/**
		A shorter `macro` alternative to `Animate.set` for adding tweens.
		@param field The target and property to animate (e.g., `object.alpha`).
		@param to The final value the property should animate to.
		@param time Duration of the tween.
		@param easing (Optional) Easing function to control the animation curve. See `heaps.Easing` for available options.
		@param delay (Optional) Delay before the tween starts.
	*/
	public macro function add(field:Expr, ethis:ExprOf<Dynamic>, to:ExprOf<Float>, time:ExprOf<Float>, ?easing:ExprOf<String>, ?delay:ExprOf<Float>) {
		var target;
		var setter;

		switch ethis.expr {
			case EField(e, f) : 
				target = e; 
				setter = f;
			default :
				return macro null;
		}

		var ease = macro "linear";
		var wait = macro 0;

		switch(easing.expr) {
			case EConst(CString(v)) : ease = easing;
			case EConst(CFloat(v)) : wait = easing;
			case EConst(CInt(v)) : wait = easing;
			default : ease = easing;
		}
		switch(delay.expr) {
			case EConst(CIdent("null")) : 
			default : wait = delay;
		}
	
		return macro $field.set($target, $v{setter}, $to, $time, $ease, $wait);
	}


	/**
		Call a function after a specified delay.
		@param complete The function to be executed after the delay.
		@param time The delay duration before the function is called.
	**/
	public function call(complete:Void->Void, time:Float):Trait {
		var trait = new Trait();

		trait.time = time * fps/1000;
		trait.complete = complete;
		trait.done = false;

		process.push(trait);

		return trait;
	}


	public function update(delta:Float) {
		for (tween in animate) {
			tween.update(delta);
		}
		for (tween in animate) {
			if (tween.done) animate.remove(tween);
		}

		for (trait in process) {
			trait.update(delta);
		}
		for (trait in process) {
			if (trait.done) process.remove(trait);
		}
	}


	/** Count all working tweens. **/
	public function count() {
		return animate.length;
	}


	/** 
		For safe usage, all tweens have an overwrite mechanism — older tweens with the same property will be removed. 
		The exception is tweens with a delay. 
	**/
	function terminate(target:Dynamic, setter:String) { 
		if (animate == null) return;

		for (tween in animate) {
			if (tween.done) continue;
			if (tween.target == target && tween.setter == setter) animate.remove(tween);
		}
	}


	/** Remove all tweens for the target. **/
	public function remove(target:Dynamic) {
		for (tween in animate) {
			if (tween.target == target) tween.done = true; 
		}
	}


	public function dispose() {
		animate = null;
		process = null;
	}
}


class Tween {
	public var target:Dynamic;
	
	public var setter:String;
	public var from:Float;
	public var to:Float;
	
	public var ease:Float->Float;

	public var time:Float;
	public var speed:Float;
	public var delay:Float;
	public var step:Float;
	
	public var complete:Void->Void;
	public var autoclear:Bool;
	public var done:Bool;


	public function new() {}


	public function update(delta:Float) {
		if (done) return;

		if (delay > 0) { 
			delay -= delta;
			if (delay <= 0) from = Reflect.field(target, setter);

			return;
		}

		if (time == 0) visible(true);

		time += speed * delta;
		step = ease(time);
	
		if (time < 1) {
			var dist = to - from;
			var val = from + step * dist;

			Reflect.setProperty(target, setter, val);
		}
		else {
			var v = from + (to - from) * 1;
			Reflect.setProperty(target, setter, v);

			visible(false);

			if (complete != null) complete();
			complete = null;

			if (autoclear) target.remove();
			autoclear = false;

			done = true; 
		}
	}


	// Automaticaly sets `target.visible` based on the target alpha value. 
	function visible(display:Bool) {
		if (display) target.visible = true;
		if (!display && target.alpha == 0) target.visible = false;
	}


	/** Auto-cleanup parameter, which will remove the target from the scene at the end of the tween. **/
	public function remove():Tween {
		autoclear = true;
		return this;
	}


	/** A callback function that will be invoked at the end of the tween duration. **/
	public function end(c:Void->Void):Tween {
		complete = c;
		return this;
	}
}


class Trait {
	public var complete:Void->Void;
	public var time:Float;
	public var done:Bool;


	public function new() {}


	public function update(delta:Float) {
		if (done) return;

		if (time > 0) time -= delta;
		if (time <= 0) {
			complete();
			done = true; 
		}
	}
}