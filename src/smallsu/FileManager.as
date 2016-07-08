package smallsu
{
	import com.adobe.utils.macro.Expression;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import crypto.KCrypto;
	
	import smallsu.Uuid;
	
	public class FileManager
	{

			//写入文件
			//调用写文件的方法
			//FastSave_clickHandler("ni ma bi");
			//调用读文件的方法
			//trace(FastLoad_clickHandler());
			
			//快速保存文件 , 以下代码 新建了一个文件。然后写入了一段字符串后，保存整个文件。
			public static function FastSave_clickHandler(str:String):void
			{
				//加密写入的字符串
				str=KCrypto.encryptByAES(str,Uuid.GetUIDValue());
				
				//打印路径
				trace(File.applicationStorageDirectory.resolvePath("license.txt").nativePath);
				
				//写入
				var file:File = new File(File.applicationStorageDirectory.resolvePath("license.txt").nativePath);
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.WRITE);
				fs.position = 0;
				fs.writeUTFBytes(str);
				fs.writeBytes(new ByteArray);
				fs.close();
			}
			
			
			//快速载入，指定文件所在位置，直接打开，并把信息显示出来
			public static function FastLoad_clickHandler():String
			{	
				try{
					//读取
					var file:File = new File(File.applicationStorageDirectory.resolvePath("license.txt").nativePath);
					
					//打印路径
					trace(File.applicationStorageDirectory.resolvePath("license.txt").nativePath);
					
					if(file.exists){
						var fs:FileStream = new FileStream();
						var str:String;
						fs.open(file,FileMode.READ);
						str = fs.readUTFBytes(fs.bytesAvailable);
						fs.close();
						
						//解密写入的字符串
						str = KCrypto.decryptByAES(str,Uuid.GetUIDValue());
						
						return str;
					}else{
						var fs:FileStream = new FileStream();
						fs.open(file,FileMode.WRITE);
						fs.position = 0;
						fs.writeUTFBytes("还没有授权过");
						fs.writeBytes(new ByteArray);
						fs.close();
						
						return "还没有授权过";
					}
				}catch(e:Expression){
					return null;
				}
				
			}

	}
}