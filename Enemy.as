package  {
	
	import flash.display.MovieClip;
	
	
	public class Enemy extends MovieClip {
		var speed: int;
		var momentum: int;
		
		public function Enemy() {
			// constructor code
			gotoAndStop(1);
			speed = 5 + Math.random()*5;
			momentum = 10 - Math.random()*20;
		}
		
		function updateEnemy()
		{
			this.y += speed;
			this.x += momentum;
			if (this.x < 0||this.x > 840)
			{
				momentum = momentum * (-1);
			}
			
		}
	}
	
}
