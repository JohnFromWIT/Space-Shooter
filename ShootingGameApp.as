package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.sensors.Accelerometer; 
	import flash.events.AccelerometerEvent;
	
	
	public class ShootingGameApp extends MovieClip {
		var starTimer : Timer;
		var loadTimer: Timer;
		var gameTimer: Timer;
		var gameOverTimer: Timer;
		var infoTimer: Timer;
		var star: Stars;
		var starArray: Array;
		var bullet: Bullet;
		var bulletArray: Array;
		var enemy: Enemy;
		var enemyArray: Array;
		var bulletAList: int;
		var enemyAList: int;
		var menuOption: MenuOption;
		var explosion: Explosion;
		var attack: Number;
		var i: int;
		var j: int;
		var health: int;
		var highscore: int;
		var score: int;
		var starA: int;
		var momentum: int;
		var shooting: int;
		var bulletCooldown: int;
		var fl_Accelerometer:Accelerometer;
		
		public function ShootingGameApp() {
			// constructor code
			stop();
			highscore = 0;
			fl_Accelerometer = new Accelerometer();
			reset();
			mmenu();			
			layTimers();
			layArrays();
			addListeners();
			menuListeners();
			starPopulate();
			starTimer.start();

		}
		
		function reset()
		{
			bulletCooldown = 0;
			momentum = 0;
			score = 0;
			health = 10;
			attack = 5;
			
		}

		function instr(e:MouseEvent)
		{
			gotoAndStop(4);
			infoTimer.start();
		}
		
		function aboutScene(e:MouseEvent)
		{
			gotoAndStop(5);
			infoTimer.start();
		}
		
		
		function mmenu()
		{
			gotoAndStop(1);
			reset();
		}
		
		function loadGame1(e:MouseEvent)
		{
			trace("Started");
			reset();
			playGame.gotoAndPlay(16);
			loadTimer.start();
			removeMenuListeners();

		}
		
		function loadGame2(e:TimerEvent)
		{
			gotoAndStop(2);
			gameTimer.start();
			reset();
		}
		
		function gameOn(e:TimerEvent)
		{
			gotoAndStop(3);
			reset();
			updateHealth();
			gameListeners();
		}
		
		function calculate(e:TimerEvent)
		{

			removeSprites();
			if (score>highscore)
			{
				highscore=score;
			}
			mmenu();

		}
		
		
		function layTimers():void
		{
			starTimer = new Timer(100);
			loadTimer = new Timer(400, 1);
			gameTimer = new Timer(20, 1);
			gameOverTimer = new Timer(200, 1);
			infoTimer = new Timer(3500, 1);
			

		}

		function layArrays():void
		{
			starArray = new Array();
			bulletArray = new Array();
			enemyArray = new Array();
	
		}
		
		function addListeners():void
		{
			starTimer.addEventListener(TimerEvent.TIMER, makeStar);
			fl_Accelerometer.addEventListener(AccelerometerEvent.UPDATE, fl_AccelerometerUpdateHandler);		
			stage.addEventListener(Event.ENTER_FRAME, updateStars);
			loadTimer.addEventListener(TimerEvent.TIMER, loadGame2);
			gameTimer.addEventListener(TimerEvent.TIMER, gameOn);
			gameOverTimer.addEventListener(TimerEvent.TIMER, calculate);
			infoTimer.addEventListener(TimerEvent.TIMER, calculate);
			playGame.addEventListener(MouseEvent.CLICK, loadGame1);
			instructions.addEventListener(MouseEvent.CLICK, instr);
			about.addEventListener(MouseEvent.CLICK, aboutScene);
			
		}
		
		function gameListeners():void
		{
			stage.addEventListener(Event.ENTER_FRAME, updateLoop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startShooting);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopShooting);
			
		}
		
		function removeGameListeners():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, updateLoop);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startShooting);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopShooting);
			
		}
		
		function menuListeners():void{
			stage.addEventListener(Event.ENTER_FRAME, updateMenu);
			

		}
		
		function removeMenuListeners():void{
			stage.removeEventListener(Event.ENTER_FRAME, updateMenu);
			
		}
		
		function removeSprites()
		{
			for (i=0; i< enemyArray.length; i++)
			{
				removeChild(enemyArray[i]);
			}
			enemyArray.length=0;
			for (j=0; j< bulletArray.length; j++)
			{
				removeChild(bulletArray[j]);
			}
			bulletArray.length=0;
			
		}
		
		function fl_AccelerometerUpdateHandler(event:AccelerometerEvent):void
		{
			momentum = event.accelerationX*(-40);
		}

		
		function startShooting(e:MouseEvent):void
		{
			shooting = 1;
		}
		
		function stopShooting(e:MouseEvent):void
		{
			shooting = 0;
		}
		
		
		function updateLoop(e:Event):void
		{
			updateBullets(e);
			updateShip();
			updateScore();
			shootBullets();
			updateEnemies();
			updateHealth();
			hitCheck();
			if (health <= 0)
			{
				removeGameListeners();
				menuListeners();
				gameOverTimer.start();
			}
		}
		
		function updateScore()
		{
			nscore.score.text = String(score);
		}
		
		function updateHealth()
		{
			healthBar.width = health*80;
		}
		
		function updateStars(e:Event):void
		{
			for (i = 0; i < starArray.length; i++)
			{
				starArray[i].updateStar();
				if (starArray[i].y > 600)
				{
					removeChild(starArray[i]);
					starArray.splice(i,1);
				}
			}
		}
		
		function updateBullets(e:Event):void
		{
			for (i = 0; i < bulletArray.length; i++)
			{
				bulletArray[i].updateBullet(e);
				if (bulletArray[i].y < 20)
				{
					removeChild(bulletArray[i]);
					bulletArray.splice(i,1);
				}
			}
		}
		
		function updateShip():void
		{
			ship.x += momentum;

			if (ship.x < 20)
			{
				ship.x = 20;
				momentum = 0;
			}
			if (ship.x > 820)
			{
				ship.x = 820;
				momentum = 0;
			}
			
		}
		
		function updateEnemies():void
		{
			for (i = 0; i < enemyArray.length; i++)
			{
				enemyArray[i].updateEnemy();
				if (enemyArray[i].y > 520)
				{
					removeChild(enemyArray[i]);
					enemyArray.splice(i,1);
				}
			}
			if(enemyArray.length < attack)
			{
				createEnemy();
			}
		}
		

		function shootBullets():void
		{
				
			if (bulletCooldown <= 0)
			{
				if (shooting)
				{
				bulletCooldown = 2;
				createBullet();
				}
			
			}else if(bulletCooldown > 0)
			{
					
				bulletCooldown -= 1;
					
			}
			
		}
		
		function createBullet():void
		{
			bullet = new Bullet;
			bullet.x = ship.x;
			bullet.y = ship.y-50;
			bulletArray.unshift(bullet);
			addChild(bullet);
		}
		
		function createEnemy():void
		{
			enemy = new Enemy;
			enemy.x = Math.random()*840;
			enemy.y = -100;
			enemyArray.unshift(enemy);
			addChild(enemy);
		}
		
		function hitCheck():void
		{
			
			for(i=0;i<enemyArray.length;i++)
			{
				for(j=0;j<bulletArray.length;j++)
				{
					if(bulletArray[j].hitTestObject(enemyArray[i]))
					{
						removeBullet(j);
						removeEnemy(i);
						increaseScore();
						break;
					}
				}
			}
			for(i=0;i<enemyArray.length;i++)
			{
				
				if(ship.hitTestObject(enemyArray[i]))
				{
					removeEnemy(i);
					damageShip();
					break;
				}
			}
		}
		
		function damageShip()
		{
			health -= 1;
		}
		
		function removeEnemy(en:int)
		{
			removeChild(enemyArray[en]);
			enemyArray.splice(en,1);
			
		}

		function removeBullet(bu:int)
		{
			removeChild(bulletArray[bu]);
			bulletArray.splice(bu,1);
			
		}
		
		function increaseScore()
		{
			score += Math.ceil(attack);
			attack += .5;
		}
		
		function updateMenu(e:Event)
		{
			gameTitle.menuText.mtext.text = "Space Shooter";
			highScore.menuText.mtext.text = String(highscore);
			playGame.menuText.mtext.text = "Start";
			instructions.menuText.mtext.text = "Instruction";
			about.menuText.mtext.text = "About";
			
		}
		
		function makeStar(e:TimerEvent)
		{
			if(starArray.length<=200)
				{
				starA = 1+Math.random()*7;
				star = new Stars;
				star.gotoAndStop(starA);
				star.x = Math.random()* 854;
				star.y = -20;
				starArray.unshift(star);
				addChild(star);
				}
		}
		
		function starPopulate()
		{
			for (i=0;i<100;i++)
			{
			starA = 1+Math.random()*7;
			star = new Stars;
			star.gotoAndStop(starA);
			star.x = Math.random()* 854;
			star.y = Math.random()*480;
			starArray.unshift(star);
			addChild(star);
				
			}
		}
		
		function makeExplosion()
		{
			explosion = new Explosion;
			explosion.x = 200;
			explosion.y = 200;
			addChild(explosion);
		}

	}
	
}
