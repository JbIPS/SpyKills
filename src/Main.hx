package ;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author jb
 */

class Main extends Sprite 
{
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new ShootRoom());
	}
	
}
