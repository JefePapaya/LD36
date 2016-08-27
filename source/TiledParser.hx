package;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;

class TiledParser 
{
	public static var PLAYER_LAYER = "Player";
	public static var BLOCK_LAYER = "Obstacles";
	public static var PORTAL_LAYER = "Creatures";
	static var X_ATTR = "x";
	static var Y_ATTR = "y";
	static var HEIGHT_ATTR = "height";
	static var TYPE_ATTR = "type";

	// public static function parseBlock(data:Xml):Block
	// {
	// 	var origin = parseXY(data);
	// 	var type = Std.parseInt(data.get(TYPE_ATTR));
	// 	var block = new Block(origin.x, origin.y, type);
	// 	block.targetPos = new FlxPoint(origin.x, origin.y);
	// 	// var type:Int = Std.parseInt(data.get(TYPE_ATTR));
	// 	for (child in data) {
	// 		if (child.nodeType == Xml.XmlType.Element) {
	// 			FlxG.log.add("child: " + child.nodeName);
	// 		}
	// 	}

	// 	for (e in data.firstElement().elementsNamed("property")) {
	// 		FlxG.log.add("found a property");
	// 		if (e.get("name") == "initial") {
	// 			block.initialPos = Std.parseInt(e.get("value"));
	// 			FlxG.log.add("found a initial value!");
	// 		}
	// 		else if (e.get("name") == "final") {
	// 			block.finalPos = Std.parseInt(e.get("value"));
	// 		}
	// 	}
	// 	FlxG.log.add("parseblock: " + data.toString());

	// 	return block;
	// }

	public static function parsePlayer(data:Xml):Player
	{
		var origin = parseXY(data);
		// var type:Int = Std.parseInt(data.get(TYPE_ATTR));

		return new Player(origin.x, origin.y);
	}

	// public static function parsePortal(data:Xml):Portal
	// {
	// 	var origin = parseXY(data);
	// 	return new Portal(origin.x, origin.y);
	// }

	static function parseXY(data:Xml):FlxPoint
	{
		var x:Int = Std.parseInt(data.get(X_ATTR));
		var y:Int = Std.parseInt(data.get(Y_ATTR));
		var height:Int = Std.parseInt(data.get(HEIGHT_ATTR));
		y -= height;
		return new FlxPoint(x, y);
	}
}