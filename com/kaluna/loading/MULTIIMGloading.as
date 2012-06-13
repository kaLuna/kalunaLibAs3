package com.kaluna.loading
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MULTIIMGloading extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_PROGRESS:String = "load_progress";
		public static const LOAD_ERROR:String = "io_error";
		public var imgAry:Array;
		private var ary:Array;
		private var cnt:int;
		private var imgLoad:IMGloading;
		private var dammy:String;
		private var flg:Boolean;
		public function MULTIIMGloading(_ary:Array,_dammy:String = "",_flg:Boolean=false)
		{
			ary = _ary;
			cnt = 0;
			dammy = _dammy;
			imgAry = [];
			flg = _flg;
			loadStart();
		}
		private function loadStart():void{
			imgLoad = new IMGloading(ary[cnt],flg);
			imgLoad.addEventListener(IMGloading.LOAD_COMPLETE,onComp);
			imgLoad.addEventListener(IMGloading.LOAD_ERROR,onErr);
		}
		private function onComp(e:Event):void{
			imgLoad.removeEventListener(IMGloading.LOAD_COMPLETE,onComp);
			imgLoad.removeEventListener(IMGloading.LOAD_ERROR,onErr);
			imgAry[cnt] = imgLoad.getBMP();
			imgLoad.rmIMG();
			imgLoad = null;
			cnt++;
			if(cnt < ary.length){
				loadStart();
			}else{
				dispatchEvent(new Event(LOAD_COMPLETE));
			}
		}
		private function onErr(e:Event):void{
			if(dammy == ""){
				imgAry[cnt] = new Bitmap();
				cnt++;
				if(cnt < ary.length){
					loadStart();
				}else{
					dispatchEvent(new Event(LOAD_COMPLETE));
				}
			}else{
				ary[cnt] = dammy;
				loadStart();
			}
		}
		public function get getAllIMG():Array{
			return imgAry;
		}
		public function getOneIMG(_num:int):Bitmap{
			return imgAry[_num];
		}
		
	}
}