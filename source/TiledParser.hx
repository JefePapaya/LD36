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
	public static var CREATURES_LAYER = "Creatures";
	public static var ENVIRONMENT_LAYER = "Environment";
	public static var ITEMS_LAYER = "Items";
	static var X_ATTR = "x";
	static var Y_ATTR = "y";
	static var HEIGHT_ATTR = "height";
	static var TYPE_ATTR = "type";
	static var NAME_ATTR = "name";

	public static function parseObject(data:Xml):Entity
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
			entity.actionText = Strings.ACTION_WOLF;
		}
		else if (name != null && name == "tree") {
			entity.makeGraphic(14, 32, FlxColor.GREEN, true);	
			entity.immovable = true;
		}
		else if (name != null && name == "axe") {
			entity.makeGraphic(14, 14, FlxColor.BLUE, true);
			entity.isVisibleInFog = false;
			entity.actionText = Strings.ACTION_AXE;
		}
		else if (name != null && name == "hut") {
			entity.makeGraphic(32, 48, FlxColor.BROWN, true);
			entity.isVisibleInFog = false;
			entity.immovable = true;
			entity.actionText = Strings.ACTION_HUT;
			var action1 = new ActionObject();
			action1.description = "Go Inside";
			action1.action = function () {
				trace("Go inside action");
			};
			entity.actions.push(action1);
			var action2 = new ActionObject();
			action2.description = "Chest";
			action2.action = function () {
				trace("Chest action");
			};
			entity.actions.push(action2);
			var action3 = new ActionObject();
			action3.description = "Fire bond";
			action3.action = function () {
				trace("Fire bond action");
			};
			entity.actions.push(action3);
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