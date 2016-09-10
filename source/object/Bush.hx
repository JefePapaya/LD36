package object;

import system.Signals;
import system.TiledParser;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;
using util.SpriteUtil;
using flixel.util.FlxSpriteUtil;

class Bush extends Entity
{
    public var berriesCount:Int = 1;
    var _tween:FlxTween = null;

    public function new(X:Float = 0, Y:Float = 0, ?Type:Int = -1)
    {
        super(X, Y);
        type = Type;
        loadGraphic(AssetPaths.bush__png, true, 38, 32);
        animation.add("empty", [0], 1, false);
        animation.add("full", [1], 1, false);
        updateType();
    }

    public function harvest()
    {
        if (_tween == null && !isFlickering()) {
            _tween = FlxTween.tween(this, {x: x+6}, 0.125, {onComplete: function(tween:FlxTween){
                _tween = FlxTween.tween(this, {x: x-6}, 0.125, {ease:FlxEase.backOut, onComplete: finishHarvestTween});
            }});
        }
    }

    function updateType() {
        if (type == -1) {
            type = FlxG.random.int(0, 1);
        }
        if (type == 0) {
            animation.play("empty");
        }
        else {
            animation.play("full");
        }
    }

    function finishHarvestTween(tween:FlxTween) {
        _tween = null;
        if (type == 1) {
            flicker(0.25, null, null, null, function(f:FlxFlicker){
                updateType();
                var pos = new FlxPoint(x + width/2, y + width/2 + 8);
                var berries = new Item();
                TiledParser.loadEntityGraphic(berries, Item.BERRIES);
                berries.name = Item.BERRIES;
                Signals.drop.dispatch(berries, pos);
            });
        }
        type = 0;
    }
}