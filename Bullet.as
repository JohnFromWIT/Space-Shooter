package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Bullet extends MovieClip {
		var speed: int;
		
		public function Bullet() {
			// constructor code
			speed = 5;
			this.addEventListener(Event.ENTER_FRAME, updateBullet);
		}
		
		function updateBullet(e:Event)
		{
			this.y -= speed;
		}
	}
	
}
