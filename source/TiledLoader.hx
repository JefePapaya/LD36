package ;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.math.FlxRect;
import haxe.xml.Fast;
import openfl.Assets;
import haxe.xml.Fast;
import haxe.xml.Parser;

/**
 * This class is based on the OgmoLoader
 * Function comments were not properly replaced
 */
class TiledLoader
{
	public var width:Int;
	public var height:Int;

	// Helper variables to read level data
	private var _xml:Xml;
	private var _fastXml:Fast;

	/**
	 * Creates a new instance of FlxOgmoLoader and prepares the XML level data to be loaded.
	 * This object can either be contained or ovewritten. 
	 * 
	 * IMPORTANT: -> Tile layers must have the Export Mode set to "CSV".
	 *            -> First tile in spritesheet must be blank or debug. It will never get drawn so don't place them in Ogmo! 
	 *               (This is needed to support many other editors that use index 0 as empty.)
	 * 
	 * @param	LevelData	A String or Class representing the location of xml level data.
	 */
	public function new(LevelData:Dynamic)
	{
		// Load xml file
		var str:String = "";
		
		// Passed embedded resource?
		if (Std.is(LevelData, Class)) 
		{
			str = Type.createInstance(LevelData, []);
		}
		// Passed path to resource?
		else if (Std.is(LevelData, String))  
		{
			str = Assets.getText(LevelData);
		}

		_xml = Parser.parse(str);
		_fastXml = new Fast(_xml.firstElement());

		width = Std.parseInt(_fastXml.att.width);
		height = Std.parseInt(_fastXml.att.height);
	}

	/**
	 * Load a Tilemap. Tile layers must have the Export Mode set to "CSV".
	 * Collision with entities should be handled with the reference returned from this function. Here's a tip:
	 * 
		// IMPORTANT: Always collide the map with objects, not the other way around. 
		//            This prevents odd collision errors (collision separation code off by 1 px).
		FlxG.collide(map, obj, notifyCallback);
	 * 
	 * @param	TileGraphic		A String or Class representing the location of the image asset for the tilemap.
	 * @param	TileWidth		The width of each individual tile.
	 * @param	TileHeight		The height of each individual tile.
	 * @param	TileLayer		The name of the layer the tilemap data is stored in Ogmo editor, usually "tiles" or "stage".
	 * @return	A FlxTilemap, where you can collide your entities against.
	 */ 
	public function loadTilemap(TileGraphic:Dynamic, TileWidth:Int = 16, TileHeight:Int = 16, TileLayer:String = "data"):FlxTilemap
	{
		var tileMap:FlxTilemap = new FlxTilemap();
		tileMap.loadMapFromCSV(_fastXml.node.layer.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight, 1);
		return tileMap;
	}

	/**
	 * Parse every entity in the specified layer and call a function that will spawn game objects based on their name. 
	 * Optional data can be read from the xml object, here's an example that reads the position of an object:
	 * 
		public function loadEntity(type:String, data:Xml):Void
		{
			switch (type.toLowerCase())
			{
			case "player":
				player.x = Std.parseFloat(data.get("x"));
				player.y = Std.parseFloat(data.get("y"));
			default:
				throw "Unrecognized actor type '" + type + "' detected in level file.";
			}
		}
	 * 
	 * @param	EntityLoadCallback		A function that takes in the following parameters (name:String, data:Xml):Void (returns Void) that spawns entities based on their name.
	 */ 
	public function loadObjectgroups(EntityLoadCallback:String->Xml->Void):Void
	{
		var objectGroups = _fastXml.nodes.objectgroup;

		// Iterate over layers of objectGroup
		for (objectGroup in objectGroups)
		{
			if (!objectGroup.has.visible || objectGroup.att.visible != "0")
			{
				// Iterate over actors
				for (e in objectGroup.elements) 
				{
					EntityLoadCallback(objectGroup.att.name, e.x);
				}
			}
		}
	}
	
	/**
	 * Parse every 'rect' in the specified layer and call a function to do something based on each rectangle.
	 * Useful for setting up zones or regions in your game that can be filled in procedurally.
	 * 
	 * @param	RectLoadCallback	A function that takes in the Rectangle object and returns Void.
	 * @param	RectLayer			The name of the layer which contains 'rect' objects.
	 */
	public function loadRectangles(RectLoadCallback:FlxRect->Void, RectLayer:String = "rectangles"):Void
	{
		var rects = _fastXml.node.resolve(RectLayer);
		
		for (r in rects.elements)
		{
			RectLoadCallback(FlxRect.get(Std.parseInt(r.x.get("x")), Std.parseInt(r.x.get("y")), Std.parseInt(r.x.get("w")), Std.parseInt(r.x.get("h"))));
		}
	}
	    
	/**
	 * Allows for loading of level properties specified in Ogmo editor.
	 * Useful for getting properties without having to manually edit the FlxOgmoLoader
	 * Returns a String that will need to be parsed
	 *
	 * @param name A string that corresponds to the property to be accessed
	 */
	public inline function getProperty(name:String):String
	{
		return _fastXml.att.resolve(name);
	}
}
