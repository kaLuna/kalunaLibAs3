package com.kaluna.net
{
	import air.net.*;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class NETMONITOR extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_PROGRESS:String = "load_progress";
		public static const LOAD_ERROR:String = "io_error";
		private var url:String;
		private var num:int;
		public function NETMONITOR(_url:String = "http://www.google.co.jp/",_num:int = 3)
		{
			super();
			url = _url;
			num = _num * 1000;
		}
		//オンラインかオフラインかを判別　常時監視
		function onURLStatusCheckTimer(e:StatusEvent):void {
			//オンライン true でオンライン falseでオフライン
			trace(e.target.available);
		}
		
		//ネットワークの監視
		function networkMonitorCheckTimer(e:TimerEvent):void {
			var request:URLRequest = new URLRequest(url);
			var monitor:URLMonitor = new URLMonitor(request);
			
			monitor.addEventListener(StatusEvent.STATUS, onURLStatusCheckTimer);
			monitor.start();
		}
		
		//タイマー3秒に一回ずつ実行
		function netCheckTimerStart():void {
			var timer:Timer = new Timer(num);
			
			timer.addEventListener(TimerEvent.TIMER, networkMonitorCheckTimer);
			timer.start();
		}
	}
}