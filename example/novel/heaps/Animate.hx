package heaps;

import haxe.macro.Expr;


class Animate {
	var array:Array<Tween> = [];
	var stack:Array<Call> = [];
	var fps:Float = 60;


	public function new(baseFps:Float) {
		fps = baseFps;
	}


	public function set(target:Dynamic, property:String, to:Float, time:Float, ?ease:String = "linear", ?delay:Float = 0):Tween {
		var tween:Tween = new Tween();

		tween.target = target;
		tween.ease = heaps.Easing.get(ease);

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

		array.push(tween);

		return tween;
	}

	
	/**
		Add tween.

		[Tween Parameters]
		- `target.property`: The target and property to animate.
		- `to`: The value to animate to.
		- `time`: The duration of the tween.
		- `ease`: The easing function for the tween — `heaps.Easing`.
		- `delay`: Optional delay before the tween starts.
	**/
	public macro function add(ethis:Expr, field:ExprOf<Dynamic>, to:ExprOf<Float>, time:ExprOf<Float>, ?eExpr:ExprOf<String>, ?dExpr:ExprOf<Float>) {
		var target;
		var setter;

		switch field.expr {
			case EField(e, f) : 
				target = e; 
				setter = f;
			default :
				return macro null;
		}

		var ease = macro "linear";
		var delay = macro 0;

		switch(eExpr.expr) {
			case EConst(CString(v)) : ease = eExpr;
			case EConst(CFloat(v)) : delay = eExpr;
			case EConst(CInt(v)) : delay = eExpr;
			default : ease = eExpr;
		}
		switch(dExpr.expr) {
			case EConst(CIdent("null")) : 
			default : delay = dExpr;
		}
	
		return macro $ethis.set($target, $v{setter}, $to, $time, $ease, $delay);
	}


	// Delayed call
	public function call(complete:Void->Void, time:Float):Call {
		var tween = new Call();

		tween.time = time * fps/1000;
		tween.complete = complete;
		tween.done = false;

		stack.push(tween);

		return tween;
	}


	public function update(delta:Float) {
		for (tween in array) {
			tween.update(delta);
		}
		for (tween in array) {
			if (tween.done) array.remove(tween);
		}

		for (call in stack) {
			call.update(delta);
		}
		for (call in stack) {
			if (call.done) stack.remove(call);
		}
	}


	/** Count all working tweens. **/
	public function count() {
		return array.length;
	}


	/** 
		For safe usage, all tweens have an overwrite mechanism — older tweens with the same property will be removed. 
		The exception is tweens with a delay. 
	**/
	function terminate(target:Dynamic, setter:String) { 
		if (array == null) return;

		for (tween in array) {
			if (tween.done) continue;
			if (tween.target == target && tween.setter == setter) array.remove(tween);
		}
	}


	/** Remove all tweens for the target. **/
	public function remove(target:Dynamic) {
		for (tween in array) {
			if (tween.target == target) tween.done = true; 
		}
	}


	public function dispose() {
		array = null;
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


class Call {
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