package smallsu
{
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.net.NetworkInterface;
	import flash.net.NetworkInfo;
	import crypto.KCrypto;
	
	public class Uuid
	{
		//获取文件UID
		 public static function GetUIDValue():String{
			var netWorkVec:Vector.<NetworkInterface >  = NetworkInfo.networkInfo.findInterfaces();
			var uid:String = "uid";
			for (var i:* in netWorkVec) {uid+="_";uid+=netWorkVec[i].hardwareAddress;}
			trace(uid);
			return uid;
		}
	}
}