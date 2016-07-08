package smallsu
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import crypto.KCrypto;
	
	import uiwidgets.DialogBox;
	
	import util.JSON;
	
	public class Register{
	
		public var sasd:String =KCrypto.encryptByAES("233333","233333");
		
//		public static function CheckActiveCode(code:String):Boolean{
//			
//			return true;
//		} 
//		
		public static function CheckIsActive():Boolean{
			
			return false;
		}
		
		/////////////////////////////////////////////////////////////////////
		//回调
		public static function CheckActiveCode(activecode:String,UID:String,result:Function):void{
			//请求的参数
			var values:URLVariables =new URLVariables();
			values.activecode=activecode;
			values.platform="android";
			values.UID=UID;
			trace(UID);
			trace(activecode);
			
			try
			{
			
				//请求的头和地址
				var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
				var request:URLRequest=new URLRequest("https://xkids.xyz:8443/sky/validate/?time="+Math.random()*1000);
				
				trace(request.url);
				
				//执行请求
				request.data=values;
				request.requestHeaders.push(header);
				request.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, completehandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				//开始执行
			
				loader.load(request);
			}
			catch(e:*){
				
				trace("An IOErrorEvent has occurred.");
				
			}
			//回调
			function ioErrorHandler(e:IOErrorEvent)
			{
				//没联网的回调
				trace(e.text+"\n"+e.type);
				result(false,"网络连接出错，请连网后再重试");
			}
			//回调
			function completehandler(event:Event):void{
				trace(event.target.data);
				var specsObj:Object;
				try {
					specsObj = util.JSON.parse(URLLoader( event.target ).data );
					trace(specsObj.message);
					result(specsObj.success,specsObj.message);
				} catch(e:*) {
					trace("A JSONError has occurred.");
					result(false,"服务器返回的数据格式不对");
				}
	
			}
		}
		/////////////////////////////////////////////////////////////////////////////////
	}
}