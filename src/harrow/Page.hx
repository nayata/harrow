package harrow;

class Page {
	public static inline var TEXT:String = "text";
	public static inline var DIALOGUE:String = "dialogue";
	public static inline var BREAK:String = "break";

	public static inline var ROUTE:String = "route";
	public static inline var MOVE:String = "move";

	public static inline var CONDITION:String = "condition";
	public static inline var VARIABLE:String = "variable";
	public static inline var EVENT:String = "event";

	public var type:String = "";
	public var text:String = "";
	public var data:String = "";
	public var tags:String = "";
	
	public function new() {}
}