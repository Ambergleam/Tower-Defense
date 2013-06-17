package{
	//imports
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	public class DirectBlock extends MovieClip{//we'll call it a DirectBlock
		private var _root:MovieClip;//again, defining a _root
		private var directType:String;//what kind of special block is this
		
		//this time, we have to accept some values to make it easier to place, like the type and coordinates
		public function DirectBlock(type:String,xVal:int,yVal:int,active:Boolean){
			directType = type;//set the directType so that all other functions can use it
			if (active) {
				//add the required event listeners
				this.addEventListener(Event.ADDED, beginClass);
				this.addEventListener(Event.ENTER_FRAME, eFrame);
			}
			//setting the coordinates
			this.x = xVal;
			this.y = yVal;
			
			if(directType == 'START'){//if this is a start block
				this.graphics.beginFill(0xFFFFFF);
				this.graphics.drawRect(0,0,25,25);
				this.graphics.endFill();
			} else if (directType == 'FINISH'){//if this is a finish block
				this.graphics.beginFill(0x777777);
				this.graphics.drawRect(0,0,25,25);
				this.graphics.endFill();
			} else {
				this.graphics.beginFill(0x111111);
				this.graphics.drawRect(0,0,25,25);
				this.graphics.endFill();
			}
			
		}
		
		private function beginClass(e:Event):void{
			_root = MovieClip(root);//setting the _root again
			
			
			
			if(directType == 'START'){//if this is a start block
				//then define the startDir and StartCoord based on it's coordinates
				if(this.x == 0+_root.xbuf){
					_root.startDir = 'RIGHT';
					_root.startCoord = this.y;
				} else if (this.y == 0+_root.ybuf){
					_root.startDir = 'DOWN';
					_root.startCoord = this.x;
				} else if (this.x == 600+_root.xbuf){
					_root.startDir = 'LEFT';
					_root.startCoord = this.y;
				} else if (this.y == 325+_root.ybuf){
					_root.startDir = 'UP';
					_root.startCoord = this.x;
				} else {
					//this level won't work if not any of these values
				}
			} else if (directType == 'FINISH'){//if this is a finish block
				//then define the finDir based on it's coordinates
				if(this.x == 0+_root.xbuf){
					_root.finDir = 'LEFT';
				} else if (this.y == 0+_root.ybuf){
					_root.finDir = 'UP';
				} else if (this.x == 600+_root.xbuf){
					_root.finDir = 'RIGHT';
				} else if (this.y == 325+_root.ybuf){
					_root.finDir = 'DOWN';
				} else {
					//this level won't work if not any of these values
				}
			}
		}
		private function eFrame(e:Event):void{
			if(_root.gameOver == true){//destroy this if the game's over
				this.removeEventListener(Event.ENTER_FRAME, eFrame);
				MovieClip(this.parent).removeChild(this);
			}
			
			if(directType != 'START' && directType != 'FINISH'){//if this isn't a start of finish block
				//then it'll act as a directioning block
				for(var i:int = 0;i<_root.enemyHolder.numChildren;i++){//create a loop
					var enTarget = _root.enemyHolder.getChildAt(i);//this will hold a certain enemy
					//if the enTarget's coordinates are too close to this block
					if(this.x >= enTarget.x - enTarget.width*.5 && this.x <= enTarget.x + enTarget.width*.5
					&& this.y >= enTarget.y - enTarget.height*.5 && this.y <= enTarget.y + enTarget.height*.5){
						//then move the enemy's direction based on what direction this block points to
						if(directType == 'UP'){
							enTarget.xSpeed = 0;
							enTarget.ySpeed = -enTarget.maxSpeed;
						} else if(directType == 'RIGHT'){
							enTarget.xSpeed = enTarget.maxSpeed;
							enTarget.ySpeed = 0;
						} else if(directType == 'DOWN'){
							enTarget.xSpeed = 0;
							enTarget.ySpeed = enTarget.maxSpeed;
						} else if(directType == 'LEFT'){
							enTarget.xSpeed = -enTarget.maxSpeed;
							enTarget.ySpeed = 0;
						}
					}
				}
			}
		}
	}
}
