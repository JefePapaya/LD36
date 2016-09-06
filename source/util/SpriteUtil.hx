package util;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class SpriteUtil
{
    /*
        Center object according to target's position
        and width and height attributes
    */
    public static function centerIn(object:FlxObject, target:FlxObject)
    {
        object.x = target.x + (target.width - object.width) / 2;
        object.y = target.y + (target.height - object.height) / 2;
    }
    /*
        Center object according to target's position
        and frameWidth and frameHeight (graphics) attributes
    */
    public static function centerInGraphics(object:FlxSprite, target:FlxSprite)
    {
        object.x = target.x - target.offset.x + (target.frameWidth - object.frameWidth) / 2;
        object.y = target.y - target.offset.y + (target.frameHeight - object.frameHeight) / 2;        
    }
    /*
        Center object in Point
    */
    public static function centerInPoint(object:FlxObject, target:FlxPoint)
    {
        object.x = target.x - object.width / 2;
        object.y = target.y - object.height / 2;        
    }
}