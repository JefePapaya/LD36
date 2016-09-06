package;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class TiledParser 
{
	public inline static var PLAYER_LAYER = "Player";
	public inline static var ENTITY_LAYER = "Entities";
	public inline static var CREATURES_LAYER = "Creatures";
	public inline static var ENVIRONMENT_LAYER = "Environment";
	public inline static var ITEMS_LAYER = "Items";
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

		if (type != null) {
			entity.type = type;
		}

		switch name {
			case Entity.TREE:
				entity.actionText = "Tree";
			case Entity.WOLF: 
				entity.actionText = Strings.ACTION_WOLF;
			default:
		}

		loadEntityGraphic(entity, name, type);

		return entity;
	}

	public static function parseItem(data:Xml):Item
	{
		var origin = parseXY(data);
		var type = Std.parseInt(data.get(TYPE_ATTR));
		var name = data.get(NAME_ATTR);
		var item = new Item(origin.x, origin.y);

		switch name {
			case Item.BERRIES:	
				item.actionText = Item.BERRIES;
			case Item.BERRY:
				item.actionText = Item.BERRY;
			case Item.FUR:
			case Item.MEAT:
			case Item.OIL:
			case Item.STONE:
			case Item.WOOD:
			default:
		}

		loadEntityGraphic(item, name);
		return item;
	}

	static function loadEntityGraphic(entity:Entity, name:String, ?type:Int=null) {
		//Load the corresponding entity
		var path = "assets/images/objects/" + name;
		if (type != null) {
			path = path + "_" + type;
		}
		path = path + ".png";

		entity.loadGraphic(path);
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