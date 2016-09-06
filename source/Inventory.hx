package;

import flixel.FlxG;
import flash.geom.Rectangle;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.util.FlxColor;
using util.SpriteUtil;

class Inventory extends FlxTypedGroup<FlxSprite>
{
    public var width(default, null):Int = StyleConfig.INVENTORY_WIDTH;
    public var height(default, null):Int = StyleConfig.INVENTORY_HEIGHT;
    public var container(default, null):FlxSprite;
    public var numSlots:Int;
    public var usedSlots:Int;
    var _slots:Array<Slot>;
    var _items:Array<Item>;

    public function new (maxSlots:Int = 12)
    {
        super();

        numSlots = maxSlots;
        usedSlots = 0;
        _slots = new Array<Slot>();
        _items = new Array<Item>();

        var sliceArray:Array<Int> = [0, 0, 1, 1]; 
        container = new FlxUI9SliceSprite(0, 0, null, new Rectangle(0, 0, width, height));
        add(container);

        // var slotRect = new Rectangle(0, 0, StyleConfig.INVENTORY_SLOT_WIDTH, StyleConfig.INVENTORY_SLOT_HEIGHT);
        for (i in 0...numSlots) {
            var slot = new Slot(i);
            // var slot = new FlxUI9SliceSprite(0, 0, null, slotRect);
            // slot.width += StyleConfig.INVENTORY_SLOT_SPACING_X;
            // slot.height += StyleConfig.INVENTORY_SLOT_SPACING_Y;
            // slot.centerOffsets();
            _slots.push(slot);
            add(slot);
        }

        forEach(function (spr:FlxSprite){
            spr.scrollFactor.set();
        });

        //Puts all the slots into place
        updateSpritePositions();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function getSlotAtPosition(position:FlxPoint):Slot
    {
        for (slot in _slots) {
            if (slot.overlapsPoint(position)) {
                return slot;
            }
        }
        return null;
    }

    public function setPosition(x:Float, y:Float)
    {
        container.setPosition(x, y);
        updateSpritePositions();
    }

    /**
        Inserts an item in the first slot and offsets
        all other items. Return true if the item was
        added, otherwise false (inventory full)
    **/
    public function putItem(item:Item):Bool {
        trace("put item");
        trace("items length: + " + _items.length);  
        if (usedSlots < numSlots) {
            _items.insert(0, item);
            usedSlots++;
            for (i in 0..._slots.length) {
                if (i < _items.length) {
                    _slots[i].item = _items[i];
                    item.scrollFactor.set();
                }
            }
            updateItemPositions();
            trace("put item return true");
            return true;
        }
        trace("put item return false");
        return false;
    }

    public function removeItem(item:Item):Bool {
        for (i in 0..._slots.length) {
            var slot = _slots[i];
            if (slot.item == item) {
                slot.item = null;
                _items[i] = null;
                updateItemPositions();
                return true;
            }
        }
        return false;
    }

    function updateSpritePositions() 
    {
        updateSlotPositions();
        updateItemPositions();
    }

    function updateSlotPositions()
    {
        var spacingX = StyleConfig.INVENTORY_SLOT_SPACING_X;
        var spacingY = StyleConfig.INVENTORY_SLOT_SPACING_Y;
        var slotsPerRow = StyleConfig.INVENTORY_SLOTS_PER_ROW;
        var slotWidth = StyleConfig.INVENTORY_SLOT_WIDTH;
        var paddingX = (container.width - slotsPerRow * (slotWidth + spacingX)) / 2;
        var paddingY = 32;
        var index:Int = 0;
        for (slot in _slots) {  
            var column = index % slotsPerRow;
            var row = Math.floor(index/slotsPerRow);  
            slot.x = container.x + paddingX + (column * (slot.frameWidth + spacingX));
            slot.y = container.y + paddingY + (row * (slot.frameHeight + spacingY));
            index++;
        }
    }

    public function updateItemPositions()
    {
        forEach(function(member:FlxSprite) {
            if (Std.is(member, Item)) {
                remove(member);
            }
        });

        for (i in 0..._slots.length) {
            var slot = _slots[i];
            if (i <= _slots.length) {
                var item = slot.item;
                if (item != null) {
                    item.centerInGraphics(slot);
                    add(item);
                }
            }
        }
    }
}

class Slot extends FlxUI9SliceSprite
{
    public var item:Item;
    public var index:Int;

    public function new (?item:Item=null, index:Int = 0)
    {
        var slotRect = new Rectangle(0, 0, StyleConfig.INVENTORY_SLOT_WIDTH, StyleConfig.INVENTORY_SLOT_HEIGHT);
        super(0, 0, null, slotRect);
        width += StyleConfig.INVENTORY_SLOT_SPACING_X;
        height += StyleConfig.INVENTORY_SLOT_SPACING_Y;
        centerOffsets();
    }
}