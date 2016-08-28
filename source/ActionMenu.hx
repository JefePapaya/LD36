package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class ActionMenu extends FlxGroup
{
	public var entity:Entity;
	var _box:FlxSprite;
	var _grpActionButtons:FlxTypedGroup<FlxSprite>;
	var _actions:Array<ActionObject>;

	public function new(source:Entity)
	{
		super();

		entity = source;
		_actions = source.actions;

		_box = new FlxSprite();
		_box.makeGraphic(100, _actions.length * 20 + 16, 0x66000000, true);
		positionBox();
		add(_box);

		_grpActionButtons = new FlxTypedGroup<FlxSprite>();
		for (action in _actions) {
			var btn = new FlxText(0, 0, _box.width - 16, action.description);
			_grpActionButtons.add(btn);
		}

		add(_grpActionButtons);

		setVisible(false);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateButtonsPosition();
		updateInput();
	}

	public function show()
	{
		positionBox();
		updateButtonsPosition();
		setVisible(true);
		FlxG.log.add("show ActionMenu");
	}

	public function hide()
	{

	}

	function setVisible(visible:Bool)
	{
		_box.visible = visible;
		_grpActionButtons.forEach(function(btn:FlxSprite){
			btn.visible = visible;
		});
	}

	function positionBox()
	{
		_box.setPosition(entity.x + entity.width, entity.y);
	}

	function updateButtonsPosition()
	{
		var i:Int = 0;
		_grpActionButtons.forEach(function(btn:FlxSprite) {
			btn.setPosition(_box.x + 8, _box.y + 8 + i * 20);
			i++;
		});
	}

	function updateInput()
	{
		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justReleased) {
			if (FlxG.mouse.overlaps(_grpActionButtons)) {
				//see button
				_grpActionButtons.forEach(function(btn:FlxSprite) {
					if (FlxG.mouse.overlaps(btn)) {
						var index = _grpActionButtons.members.indexOf(btn);
						_actions[index].action();
						return;
					}
				});
			}
		}
		#end
	}
}