package;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class TiledParser 
{
	public static var PLAYER_LAYER = "Player";
	public static var ENTITY_LAYER = "Entities";
	public static var PORTAL_LAYER = "Creatures";
	static var X_ATTR = "x";
	static var Y_ATTR = "y";
	static var HEIGHT_ATTR = "height";
	static var TYPE_ATTR = "type";
	static var NAME_ATTR = "name";

	public static function parseEntity(data:Xml):Entity
	{
		var origin = parseXY(data);
		var type = Std.parseInt(data.get(TYPE_ATTR));
		var name = data.get(NAME_ATTR);
		var entity = new Entity(origin.x, origin.y);

		if (name != null && name == "fire") {
			entity.makeGraphic(12, 12, FlxColor.ORANGE, true);
			entity.lightRadius = GameConfig.fireLightRadius;
		}
		else if (name != null && name == "bear") {
			entity.makeGraphic(20, 16, FlxColor.BROWN, true);
			entity.isVisibleInFog = false;
		}
		else if (name != null && name == "wolf") {
			entity.makeGraphic(14, 14, FlxColor.GRAY, true);
			entity.isVisibleInFog = false;
		}

		FlxG.log.add("parseblock: " + data.toString());

		return entity;
	}

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