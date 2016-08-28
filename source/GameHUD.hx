package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class GameHUD extends FlxTypedGroup<FlxSprite> 
{
	public static var sharedInstance:GameHUD;
	public var actionMenu:ActionMenu;

	var _focusOnPlayer:FlxText;
	var _txtAction:FlxText;
	var _actionEntity:Entity;
	var _txtStatus:FlxText;
	var _playState:PlayState;

	var _actionTxtTimer:Float = 1;
	var _statusTxtTimer:Float = 1;


	public function new(state:PlayState)
	{
		super();
		sharedInstance = this;
		_playState = state;
		_focusOnPlayer = new FlxText(0, 16, 64, "return to player");
		_focusOnPlayer.alignment = FlxTextAlign.CENTER;
		_focusOnPlayer.screenCenter(FlxAxes.X);
		add(_focusOnPlayer);

		_txtAction = new FlxText(0, 0, 120, "");
		_txtAction.alignment = FlxTextAlign.CENTER;
		_txtAction.visible = false;
		add(_txtAction);

		_txtStatus = new FlxText(0, 0, 120, Strings.ACTION_TOO_FAR);
		_txtStatus.alignment = FlxTextAlign.CENTER;
		_txtStatus.visible = false;
		_txtStatus.borderStyle = FlxTextBorderStyle.OUTLINE;
		_txtStatus.borderColor = FlxColor.BLACK;
		_txtStatus.borderSize = 1;
		_txtStatus.screenCenter(FlxAxes.XY);
		_txtStatus.alpha = 0;
		add(_txtStatus);

		forEach(function (spr:FlxSprite) {
			spr.scrollFactor.set();
		});
	}

	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		updateTextPositions();
		updateInput();
		updateTimers(elapsed);
	}

	public function displayActionText(text:String, attachTo:Entity) 
	{
		_txtAction.visible = true;
		_txtAction.text = text;
		_actionEntity = attachTo;
		_actionTxtTimer = 1;
	}

	public function displayStatusText(text:String)
	{
		_txtStatus.visible = true;
		_statusTxtTimer = 1;
	}

	public function showActionMenu(entity:Entity)
	{
		actionMenu = new ActionMenu(entity);
		actionMenu.show();
		_playState.add(actionMenu);
	}

	function updateTimers(elapsed:Float)
	{
		_actionTxtTimer -= elapsed;
		if (_actionTxtTimer < 0) {
			_txtAction.visible = false;
			_actionTxtTimer = 0;
		}
		_statusTxtTimer -= elapsed;
		if (_statusTxtTimer < 0) {
			_txtStatus.alpha = 0;
			_txtStatus.visible = false;
			_statusTxtTimer = 0;
		}
	}

	function updateTextPositions()
	{
		if (_actionEntity != null && _txtAction.visible) {
			centerSpriteOnTop(_txtAction, _actionEntity);
		}
		if (_txtStatus.visible) {
			centerSpriteBelowMouse(_txtStatus);
			_txtStatus.alpha = 1;
		}
	}

	function centerSpriteOnTop(sprite:FlxSprite, onTopOf:FlxSprite) {
		sprite.x =  onTopOf.getScreenPosition().x - sprite.width * 0.5 + onTopOf.width * 0.5;
		sprite.y = onTopOf.getScreenPosition().y - sprite.height + 4;
	}

	function centerSpriteBelowMouse(sprite:FlxSprite) {
		sprite.x =  FlxG.mouse.getScreenPosition().x - sprite.width * 0.5 + 4;
		sprite.y = FlxG.mouse.getScreenPosition().y + sprite.height + 10;
	}

	function updateInput()
	{
		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justReleased) {
			if (FlxG.mouse.overlaps(_focusOnPlayer)) {
				_playState.navigation.moveTowardsPlayer(true);
			}
			else if (_actionEntity != null && FlxG.mouse.overlaps(_actionEntity)) {
				_playState.player.getItem(_actionEntity);
			}
		}
		#end
	}
}