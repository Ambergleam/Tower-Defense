package{//creating the basic skeleton
	import flash.display.MovieClip;
	import flash.events.*;
	public class Turret extends MovieClip{
		private var _root:MovieClip;
		
		private var angle:Number; //the angle that the turret is currently rotated at
		private var radiansToDegrees:Number = 180/Math.PI;//this is needed for the rotation
		private var enTarget;//the current target that it's rotating towards
		private var cTime:int = 0;//how much time since a shot was fired by this turret
		private var loaded:Boolean = true;//whether or not this turret can shoot

		public var turretType:int;// the type code
		public var reloadTime:int;//how long it takes to fire another shot
		public var damage:int;//how much damage this little baby can inflict
		public var range:int;//how far away (in pixels) it can hit a target
		public var bullet_speed:int;
		
		public var specials:Array = [0,0,0];
		
		public var color_base:int;
		public var color_gun:int;
		public var color_bullet:int;
		public var cost:int; // cost to build
		
		public var str:String = "";
		public var homing:int;
		
		public function Turret(type:int, build:Boolean){
			this.tabEnabled = false;
			turretType = type;
			setStats();
			if (build) {
				this.buttonMode = true;
				//adding the required listeners
				this.addEventListener(Event.ADDED, beginClass);
				this.addEventListener(Event.ENTER_FRAME, eFrameEvents);
				this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);
				this.addEventListener(MouseEvent.CLICK, thisClick);//adding function for clicking
			}
		}
		
		public function setStats():void {
			switch(turretType) {
				case 0: str = "Basic"; // normal turret
					reloadTime = 24;
					damage = 1;
					range = 100;
					bullet_speed = 12;
					color_base = 0x9999999;
					color_gun = 0xFFFFFF;
					color_bullet = 0xFFFFFF;
					cost = 20;
					homing = 100;
					specials = [0,0,0];
					break;
				case 1: str = "Sniper"; // sniper turret
					reloadTime = 48;
					damage = 2;
					range = 200;
					bullet_speed = 12;
					color_base = 0x9999999;
					color_gun = 0x770000;
					color_bullet = 0x770000;
					cost = 50;
					homing = 100;
					specials = [0,0,0];
					break;
				case 2:  str = "Cannon";// cannon turret
					reloadTime = 48;
					damage = 10;
					range = 50;
					bullet_speed = 12;
					color_base = 0x9999999;
					color_gun = 0x007700;
					color_bullet = 0x007700;
					cost = 50;
					homing = 100;
					specials = [0,0,0];
					break;
				case 3: str = "Speed"; // speed turret
					reloadTime = 6;
					damage = 1;
					range = 100;
					bullet_speed = 12;
					color_base = 0x9999999;
					color_gun = 0x000077;
					color_bullet = 0x000077;
					cost = 50;
					homing = 100;
					specials = [0,0,0];
					break;
				case 666: str = "Death"; // Death turret
					reloadTime = 3;
					damage = 0;
					range = 500;
					bullet_speed = 12;
					color_base = 0x9999999;
					color_gun = 0x777777;
					color_bullet = 0x888888;
					homing = 100;
					cost = 999999999;
					specials = [-1,0,0];
					break;
			} // end switch for turret stats
		} // end function
		
		private function beginClass(e:Event):void{
			_root = MovieClip(root);
			
			//drawing the turret, it will have a gray, circular, base with a white gun
			this.graphics.beginFill(color_base);
			this.graphics.drawCircle(0,0,12.5);
			this.graphics.endFill();
			this.graphics.beginFill(color_gun);
			this.graphics.drawRect(-2.5, 0, 5, 20);
			this.graphics.endFill();
		}
		private function eFrameEvents(e:Event):void{
			if (!_root.gamePaused) {
				//FINDING THE NEAREST ENEMY WITHIN RANGE
				var distance:Number = range;//let's define a variable which will be how far the nearest enemy is
				enTarget = null;//right now, we don't have a target to shoot at
				for(var i:int=_root.enemyHolder.numChildren-1;i>=0;i--){//loop through the children in enemyHolder
					var cEnemy = _root.enemyHolder.getChildAt(i);//define a movieclip that will hold the current child
					//this simple formula with get us the distance of the current enemy
					if(Math.sqrt(Math.pow(cEnemy.y - y, 2) + Math.pow(cEnemy.x - x, 2)) < distance){
						//if the selected enemy is close enough, then set it as the target
						enTarget = cEnemy;
					}
				}
				//ROTATING TOWARDS TARGET
				if(enTarget != null){//if we have a defined target
					//turn this baby towards it
					this.rotation = Math.atan2((enTarget.y-y), enTarget.x-x)/Math.PI*180 - 90;
					if(loaded){//if the turret is able to shoot
						loaded = false;//then make in unable to do it for a bit
						var newBullet:Bullet = new Bullet(this);//create a bullet
						//set the bullet's coordinates
						newBullet.x = this.x;
						newBullet.y = this.y;
						//set the bullet's target and damage
						newBullet.target = enTarget;
						_root.addChild(newBullet);//add it to the stage
					}
				}
				//LOADING THE TURRET
				if(!loaded){//if it isn't loaded
					cTime ++;//then continue the time
					if(cTime == reloadTime){//if time has elapsed for long enough
						loaded = true;//load the turret
						cTime = 0;//and reset the time
					}
				}
				if(_root.gameOver){//destroy this if game is over
					this.removeEventListener(Event.ENTER_FRAME, eFrameEvents);
					if (_root.contains(_root.rangeCircle)) {
						_root.removeChild(_root.rangeCircle);
					}
					MovieClip(this.parent).removeChild(this);
				}
			}
		}
		private function thisMouseOver(e:MouseEvent):void{
			_root.createRangeCircle(range);
			_root.rangeCircle.x = this.x-12.5;
			_root.rangeCircle.y = this.y-12.5;
			_root.addChild(_root.rangeCircle);
		}
		private function thisMouseOut(e:MouseEvent):void{
			if (_root.contains(_root.rangeCircle)) {
				_root.removeChild(_root.rangeCircle);
			}
		}
		private function thisClick(e:MouseEvent):void{
			if (turretType == _root.t1.turretType) {
				_root.selectTower1(null);
			}
			if (turretType == _root.t2.turretType) {
				_root.selectTower2(null);
			}
			if (turretType == _root.t3.turretType) {
				_root.selectTower3(null);
			}
			if (turretType == _root.t4.turretType) {
				_root.selectTower4(null);
			}
		}
		
				
		
		
	}
}