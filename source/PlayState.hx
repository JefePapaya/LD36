package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var player:Player;
	var _background:FlxSprite;
	var _terrain:FlxSprite;
	var _stone:FlxSprite;

	override public function create():Void
	{
		super.create();

		_background = new FlxSprite();
		_background.makeGraphic(FlxG.width, FlxG.height, 0xFF99BBCC, true);
		add(_background);

		_terrain  = new FlxSprite();
		_terrain.makeGraphic(Math.round(FlxG.width * 0.5), Math.round(FlxG.height * 0.5), FlxColor.WHITE, true);
		_terrain.x = FlxG.width * 0.25;
		_terrain.y = FlxG.height * 0.25;
		_terrain.width = FlxG.width * 0.5;
		_terrain.height = FlxG.height * 0.5;
		add(_terrain);

		_stone  = new FlxSprite();
		_stone.makeGraphic(32, 32, FlxColor.GRAY, true);
		_stone.x = FlxG.width * 0.4;
		_stone.y = FlxG.height * 0.4;
		_stone.width = 32;
		_stone.height = 32;
		_stone.immovable = true;
		_stone.centerOffsets();
		add(_stone);

		player = new Player();
		player.screenCenter(FlxAxes.XY);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		updateInput();
		FlxG.collide(player, _stone, collidePlayerStone);
		//Animation must be updated after collision
		player.updateAnimation(elapsed);
	}

	function updateInput() {
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justReleased.R) {
			FlxG.resetState();
		}
		#end
	}

	function collidePlayerStone(p:Player, s:FlxSprite)
	{
		FlxG.log.add("collidePlayerStone");
	}
}
