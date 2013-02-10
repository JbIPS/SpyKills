package ;
import nme.events.Event;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author jb
 */

class Target extends ShootObject
{

	public function new(position: String) 
	{
		super(nme.Assets.getBitmapData("img/target.png"));
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
		
		if (position == "column")
			Actuate.tween(this, 2, { x: x - 100 } ).repeat(1).reflect();
		else
			Actuate.tween(this, 2, { y: y - 150 } ).repeat(1).reflect();
	}
	
}