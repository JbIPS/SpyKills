package;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.ui.Mouse;

/**
 * ...
 * @author jb
 */

class ShootRoom extends Sprite
{

	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		addEventListener(MouseEvent.CLICK, onShoot);
	}
	
	private function onShoot(e:MouseEvent):Void 
	{
		Assets.getSound("sfx/shot.mp3").play();
		Lib.trace(e.target.name);
	}

	private function init(e) 
	{
		var gunSight = new Bitmap(Assets.getBitmapData("img/gun_sight.png"));
		Mouse.hide();
		var cursor = new Sprite();
		cursor.addChild(gunSight);
		cursor.x = mouseX - gunSight.width/2;
		cursor.y = mouseY -gunSight.height/2;
		cursor.mouseChildren = cursor.mouseEnabled = false;
		Lib.current.addChild(cursor);
		cursor.startDrag();
		
		var background = new ShootObject(Assets.getBitmapData("img/background.png"));
		addChild(background);
		
		var barrel = new ShootObject(Assets.getBitmapData("img/barrel.png"));
		barrel.x = 131;
		barrel.y = 338;
		var column = new ShootObject(Assets.getBitmapData("img/column.png"));
		column.x = 565;
		column.y = 0;
		var metalCrate = new ShootObject(Assets.getBitmapData("img/metal_crate.png"));
		metalCrate.x = 270;
		metalCrate.y = 428;
		var woodenCrate = new ShootObject(Assets.getBitmapData("img/wooden_crates.png"));
		woodenCrate.x = 366;
		woodenCrate.y = 282;
		
		addChild(barrel);
		addChild(column);
		addChild(metalCrate);
		addChild(woodenCrate);
	}
	
}