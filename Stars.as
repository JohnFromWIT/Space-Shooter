package  {
	
	import flash.display.MovieClip;
	
	
	public class Stars extends MovieClip {
		var speed: int;
		
		public function Stars() {
			// constructor code
			speed = 1 + Math.random()*2;
		}
		
		function updateStar()
		{
			this.y += speed;
				
		}
	}
	
}
