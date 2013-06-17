package {
	import flash.display.MovieClip;
	import flash.events.*;
	public class Bullet extends MovieClip {
		private var _root:*;
		
		//these two variables below must be set to public so that we can edit them outside the class
		public var target;//the target that this guy is moving towards
		public var retarget:int;
		
		private var damage:int;//how much damage this guy inflicts on the enemy
		private var xSpeed:Number;//how fast it's moving horizontally
		private var ySpeed:Number;//how fast it's moving vertically
		private var maxSpeed:Number;//how fast it can go
		private var specials:Array = [0,0,0]; // special abilities
		private var color:int; // bullet color
		
		public function Bullet(turret:Turret) {
			damage = turret.damage;
			maxSpeed = turret.bullet_speed;
			specials = turret.specials;
			color = turret.color_bullet;
			retarget = turret.homing;
			addEventListener(Event.ADDED,beginClass);//this will run every time this guy is made
			addEventListener(Event.ENTER_FRAME,eFrame);//this will run every frame
		}
		
		private function beginClass(e:Event):void {
			_root = MovieClip(root);//setting the root
			
			//drawing this guy (it'll be a small white circle)
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,2);
			this.graphics.endFill();
		}
		private function eFrame(e:Event):void {
			if (_root.gameOver == false && !_root.gamePaused) {
				if((target == null || target.health <= 0) && retarget == 0){
					destroyThis();
				} else if ((target == null || target.health <= 0) && retarget > 0) {
					var distance:Number = retarget;//let's define a variable which will be how far the nearest enemy is
					var enTarget = null;//right now, we don't have a target to shoot at
					for(var i:int=_root.enemyHolder.numChildren-1;i>=0;i--){//loop through the children in enemyHolder
						var cEnemy = _root.enemyHolder.getChildAt(i);//define a movieclip that will hold the current child
						//this simple formula with get us the distance of the current enemy
						var j:int = Math.sqrt(Math.pow(cEnemy.y - y, 2) + Math.pow(cEnemy.x - x, 2));
						if(j < distance){
							//if the selected enemy is close enough, then set it as the target
							enTarget = cEnemy;
							distance = j;
						}
					}
					target = enTarget;
					if (distance == retarget) {
						destroyThis();
					}
				}
				if (target != null) {
					var yDist:Number=target.y+12.5 - this.y;//how far this guy is from the enemy (x)
					var xDist:Number=target.x+12.5 - this.x;//how far it is from the enemy (y)
					var angle:Number=Math.atan2(yDist,xDist);//the angle that it must move
					ySpeed=Math.sin(angle) * maxSpeed;//calculate how much it should move the enemy vertically
					xSpeed=Math.cos(angle) * maxSpeed;//calculate how much it should move the enemy horizontally
					//move the bullet towards the enemy
					this.x+= xSpeed;
					this.y+= ySpeed;
					
					if(this.hitTestObject(target)){//if it touches the enemy
						if (target.special == -1) {
							
						} else if (specials[0] == -1 || specials[1] == -1 || specials[2] == -1) {
							target.health = 0;
						} else {
							target.health -= damage;//make it lose some health
						}
						destroyThis();//and destroy this guy
					}
				}
			}
			if(_root.gameOver == true){//destroy it if game is over
				destroyThis();
			}
		}
		
		public function destroyThis():void{
			//this function will just remove this guy from the stage
			this.removeEventListener(Event.ENTER_FRAME, eFrame);
			MovieClip(this.parent).removeChild(this);
		}
		
	}
}