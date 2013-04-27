package ;

import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import com.eclecticdesignstudio.motion.Actuate;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author jb
 */

class Target extends ShootObject
{
	public var aliveTime: Int;
	public var popped: Bool;
	public var available: Bool = true;
	
	private var position: String;
	private var shot: Bool;
	private var origin: ShootRoom.Position;
	
	public function new(position: String, scale: Float = 1) 
	{
		this.position = position;
		super(nme.Assets.getBitmapData("img/target.png"), scale);
		switch(position) {
			case "metal": 	x = ShootRoom.metalCratePos.x+30;
							y = ShootRoom.metalCratePos.y;
			case "wooden": 	x = ShootRoom.woodenCratePos.x+30;
							y = ShootRoom.woodenCratePos.y + 10;
							scaleX = scaleY = 0.8;
			case "column": 	x = ShootRoom.columnPos.x;
							y = ShootRoom.columnPos.y + 100;
			case "barrel": 	x = ShootRoom.barrelPos.x+10;
							y = ShootRoom.barrelPos.y + 5;
							scaleX = scaleY = 0.8;
		}
		origin = { x: x, y: y };
		mouseEnabled = true;
	}
	
	public function pop() : Bool 
	{
		if (popped)
			return false;
		available = false;
			
		if (position == "column")
			Actuate.tween(this, 2*ShootRoom.accelerator, { x: origin.x - 80 } ).ease(Cubic.easeOut);
		else
			Actuate.tween(this, 2*ShootRoom.accelerator, { y: origin.y - 150 } ).ease(Cubic.easeOut);
			
		aliveTime = Lib.getTimer();
		shot = false;
			
		return popped = true;
	}
	
	public function push():Void 
	{
		popped = false;
		if (position == "column")
			Actuate.tween(this, 2*ShootRoom.accelerator, { x: origin.x} ).onComplete(reset);
		else
			Actuate.tween(this, 2*ShootRoom.accelerator, { y: origin.y } ).onComplete(reset);
	}
	
	private override function onHit(e: MouseEvent) : Void 
	{
		if(bitmapData.getPixel32(Math.round(e.localX), Math.round(e.localY)) != 0 && !shot){
			shot = true;
			ShootRoom.combo++;
			super.onHit(e);
			push();
			if(bitmapData.getPixel(Math.round(e.localX), Math.round(e.localY)) == 0xFFFFFF)
				ShootRoom.score += 50 * ShootRoom.combo;
			else {
				ShootRoom.score += 100 * ShootRoom.combo;
				ShootRoom.startTime += 1000;
				Assets.getSound("sfx/headshot.mp3").play();
				
				var points = new TextField();
				points.embedFonts = true;
				var textFormat: TextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 15, 0xFFFFFF);
				points.defaultTextFormat = textFormat;
				points.selectable = points.mouseEnabled = false;
				points.text = "+1s";
				points.x = 70;
				points.y = 70;
				Actuate.tween(points, 2*ShootRoom.accelerator, { x: x+10, alpha: 0 } ).ease(Cubic.easeOut);
				parent.addChild(points);
			}
		}
		else
			ShootRoom.combo = 1;
	}
	
	private function reset() : Void 
	{
		available = true;
		if(!shot)
			dispatchEvent(new HitEvent(HitEvent.HIT));
		
		while (numChildren > 1)
			removeChildAt(numChildren - 1);
	}
	
}