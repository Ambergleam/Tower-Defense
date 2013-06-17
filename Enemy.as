package{
	//imports
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import fl.motion.Color;

	//defining the class
	public class Enemy extends MovieClip{
		private var _root:MovieClip;
		
		public var globalMaxSpeed:int = 9;
		
		public var xSpeed:int;//how fast it's going horizontally
		public var ySpeed:int;//how fast it's going vertically
		public var maxSpeed:int;//how fast it can possibly go
		public var maxHealth:int; // max hp
		public var health:int; // current hp
		public var type:int;//this will be set to the number passed in
		public var damage:int;
		public var val:int;
		public var color:int;
		
		public var str:String;
		public var special:int;
		// Special Guide
		// -1 - invincible
		//  0 - normal
		
		public function Enemy(code:int){
			this.addEventListener(Event.ADDED, beginClass);
			this.addEventListener(Event.ENTER_FRAME, eFrameEvents);
			
			type = code;//set the level to the value passed in for use in other functions
		}
		private function beginClass(e:Event):void{
			_root = MovieClip(root);//defining the root
			
			typeCheck();
			health = maxHealth; // set current health as max health
			if (maxSpeed > globalMaxSpeed) {
				maxSpeed = globalMaxSpeed;
			}
			//checking what the start direction is
			if(_root.startDir == 'UP'){//if it's starting up
				this.y = 325+_root.ybuf;//set the y value off the field
				this.x = _root.startCoord;//make the x value where it should be
				this.xSpeed = 0;//make it not move horizontally
				this.ySpeed = -maxSpeed;//make it move upwards
			} else if(_root.startDir == 'RIGHT'){//and so on for other directions
				this.x = 0+_root.ybuf;
				this.y = _root.startCoord;
				this.xSpeed = maxSpeed;
				this.ySpeed = 0;
			} else if(_root.startDir == 'DOWN'){
				this.y = 0+_root.ybuf;
				this.x = _root.startCoord;
				this.xSpeed = 0;
				this.ySpeed = maxSpeed;
			} else if(_root.startDir == 'LEFT'){
				this.x = 600+_root.xbuf;
				this.y = _root.startCoord;
				this.xSpeed = -maxSpeed;
				this.ySpeed = 0;
			}
			
		} // end function
		
		private function eFrameEvents(e:Event):void{
			if (!_root.gamePaused) {
				//draw the actual enemy
				this.graphics.beginFill(color);
				this.graphics.drawCircle(12.5,12.5,4);
				this.graphics.beginFill(0xFF0000);
				this.graphics.drawRect(8.5,17.5,8,2);
				this.graphics.beginFill(0x00FF00);
				this.graphics.drawRect(8.5,17.5,(int)((health/maxHealth)*8),2);
				this.graphics.endFill();
				
				//move it based on x and y value
				this.x += xSpeed;
				this.y += ySpeed;
				
				//checking what direction it goes when finishing the path
				if(_root.finDir == 'UP'){//if it finishes at the top
					if(this.y <= 0+_root.ybuf){//if the y value is too high
						destroyThis();//then remove this guy from the field
						_root.lives -= damage;//take away a life
					}
				} else if(_root.finDir == 'RIGHT'){//and so on for other directions
					if(this.x >= 600+_root.xbuf){
						destroyThis();					
						_root.lives -= damage;
					}
				} else if(_root.finDir == 'DOWN'){
					if(this.y >= 325+_root.ybuf){
						destroyThis();
						_root.lives -= damage;
					}
				} else if(_root.finDir == 'LEFT'){
					if(this.x <= 0+_root.xbuf){
						destroyThis();
						_root.lives -= damage;
					}
				}
				
				//remove this from stage when game is over
				if(_root.gameOver){
					destroyThis();
				}
				
				//destroy this if health is equal to or below 0
				if(health <= 0){
					destroyThis();
					_root.money += val;
				}
			}
		}
		public function destroyThis():void{
			//this function will make it easier to remove this from stage
			this.removeEventListener(Event.ENTER_FRAME, eFrameEvents);
			this.parent.removeChild(this);
			_root.enemiesLeft --;
		}
		private function typeCheck():void{
			// determines enemy type
			switch(type) {
				case 1: str = "Green";
						maxHealth = 3;
						damage = 1;
						maxSpeed = 3;
						val = 2;
						color = 0x00FF00;
						special = 0;
						break;
				case 2: str = "Red";
						maxHealth = 3;
						damage = 1;
						maxSpeed = 3;
						val = 2;
						color = 0xFF0000;
						special = 0;
						break;
				case 3: str = "Blue";
						maxHealth = 3;
						damage = 1;
						maxSpeed = 3;
						val = 2;
						color = 0x0000FF;
						special = 0;
						break;
				case 666: str = "Death";
						maxHealth = 3;
						damage = 100;
						maxSpeed = globalMaxSpeed;
						val = 500000;
						color = 0x0000FF;
						special = -1;
						break;
			} // determines enemy type
			maxHealth *= _root.dmod;
			damage *= _root.dmod;
			val *= (1/_root.dmod);
			
		} // end function for type check
		
	}
}