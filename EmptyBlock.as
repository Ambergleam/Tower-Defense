﻿package{
	//importing required classes for this to work
	import flash.display.MovieClip;
	import flash.events.*;
	public class EmptyBlock extends MovieClip{//defining the class as EmptyBlock
		private var _root:MovieClip;//creating a _root variable to access root easily
		
		public function EmptyBlock(active:Boolean){//this function will always run once EmptyBlock is called
			this.tabEnabled = false;
			if (active) {
				this.addEventListener(Event.ADDED, beginClass);//create a function that will run once
				this.addEventListener(Event.ENTER_FRAME, eFrameEvents);//create a enterFrame function
			}
		}
		
		private function beginClass(e:Event):void{
			_root = MovieClip(root);//setting the _root as the root level
			
			this.buttonMode = true;//make this act like a button
			this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);//adding function for mouseOver
			this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);//adding function for mouseOut
			this.addEventListener(MouseEvent.CLICK, thisClick);//adding function for clicking
		}
		
		private function eFrameEvents(e:Event):void{
			if(_root.gameOver){//remove this and listeners if game is over
				this.removeEventListener(Event.ENTER_FRAME, eFrameEvents);
				this.removeEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);
				this.removeEventListener(MouseEvent.CLICK, thisClick);
				
				MovieClip(this.parent).removeChild(this);
			}
		}
		
		private function thisMouseOver(e:MouseEvent):void{
				//changing the background so the user know's it's clickable
				this.graphics.beginFill(0x006600);
				this.graphics.drawRect(0,0,25,25);
				this.graphics.endFill();
				_root.createRangeCircle(_root.selectedTurret.range);
				_root.rangeCircle.x = this.x;
				_root.rangeCircle.y = this.y;
				_root.addChild(_root.rangeCircle);
		}
		private function thisMouseOut(e:MouseEvent):void{
				//changing the background back
				this.graphics.beginFill(0x333333);
				this.graphics.drawRect(0,0,25,25);
				this.graphics.endFill();
			if (_root.contains(_root.rangeCircle)) {
				_root.removeChild(_root.rangeCircle);
			}
		}
		private function thisClick(e:MouseEvent):void{
				if(_root.money >= _root.selectedTurret.cost){//if the player has enough money
					_root.makeTurret(this.x,this.y);//make the turret
					//remove all the listeners so it can't be clicked on again
					//this.buttonMode = false;
					this.graphics.beginFill(0x333333);
					this.graphics.drawRect(0,0,25,25);
					this.graphics.endFill();
					this.removeEventListener(MouseEvent.MOUSE_OVER, thisMouseOver);
					this.removeEventListener(MouseEvent.MOUSE_OUT, thisMouseOut);
					//this.removeEventListener(MouseEvent.CLICK, thisClick);
					
					_root.money -= _root.selectedTurret.cost; //spend the money
					if (_root.contains(_root.rangeCircle)) {
						_root.removeChild(_root.rangeCircle);
					}
				}
		}
	}
}