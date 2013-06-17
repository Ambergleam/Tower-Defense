package{

	public class Wave {
		
		public var waveArray:Array;
		
		public function Wave(i:int){
			switch(i) {
				case 0: wave_0(); break;
			} // end switch
		} // end constructor
		
		public function wave_0():void {
			waveArray = [
			  [1],
			  [1],
			  [1],
			  [1],
			  [1],
			  [1]
			]; // end of waves
		} // end wave method

	}
}