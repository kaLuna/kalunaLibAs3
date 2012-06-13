package com.kaluna.signage
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Mouse;
	
	public class mouseVisible extends Sprite
	{
		public function mouseVisible()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,add);
		}
		public function add(e:Event = null):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDn);
		}
		public function remove():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDn);
		}
		private function keyDn(e:KeyboardEvent):void{
			trace(e.keyCode);
			switch(e.keyCode){
				case 83:	//S：Show
					Mouse.show();
					break;
				case 72:	//H：Hide
					Mouse.hide();
					break;
			}
		}
	}
}