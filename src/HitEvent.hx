package ;
import nme.events.Event;

/**
 * ...
 * @author jb
 */

class HitEvent extends Event
{
	public static var HIT = "HIT";

	public function new(type : String, ?bubbles : Bool, ?cancelable : Bool) 
	{
		super(type, bubbles, cancelable);
	}
	
}