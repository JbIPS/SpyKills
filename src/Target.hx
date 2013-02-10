package ;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.events.Event;
import com.eclecticdesignstudio.motion.Actuate;
import nme.events.MouseEvent;
import nme.Lib;

/**
 * ...
 * @author jb
 */

class Target extends ShootObject
{
	public var aliveTime: Int;
	public var popped: Bool;
	
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
	}
	
	public function pop() : Bool 
	{
		if (popped)
			return false;
			
		if (position == "column")
			Actuate.tween(this, 2, { x: origin.x - 100 } ).ease(Cubic.easeOut);
		else
			Actuate.tween(this, 2, { y: origin.y - 150 } ).ease(Cubic.easeOut);
			
		aliveTime = Lib.getTimer();
		shot = false;
			
		return popped = true;
	}
	
	public function push():Void 
	{
		if (position == "column")
			Actuate.tween(this, 2, { x: origin.x} ).onComplete(reset);
		else
			Actuate.tween(this, 2, { y: origin.y } ).onComplete(reset);
	}
	
	private override function onHit(e: MouseEvent) : Void 
	{
		shot = true;
		super.onHit(e);
		push();
	}
	
	private function reset() : Void 
	{
		popped = false;
		if(!shot)
			dispatchEvent(new HitEvent(HitEvent.HIT));
		
		while (numChildren > 1)
			removeChildAt(numChildren - 1);
	}
	
}