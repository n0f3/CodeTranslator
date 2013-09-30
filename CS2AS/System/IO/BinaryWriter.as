package System.IO
{

	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class BinaryWriter
	{
		public var arr:ByteArray;
		
		public function BinaryWriter()
		{
			arr = new ByteArray();
			arr.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function WriteInt64(data:Number):void
		{
			for(var i:int = 0; i < 8; i++)
				arr.writeByte(data >> (8 * i));
		}
		public function WriteByteArray(data:ByteArray):void
		{
			arr.writeBytes(data, 0, data.length);
//			for(var i:int = 0; i < data.length;i++)
//				arr.writeByte(data[i]);
		}
		public function WriteInt32(data:int):void
		{
			arr.writeInt(data);
//			for(var i:int = 0; i < 4; i++)
//				arr.writeByte(data >> (8 * i));
		}
		public function WriteUInt16(data:int):void
		{
			for(var i:int = 0; i < 2; i++)
				arr.writeByte(data >> (8 * i));
		}
		public function WriteInt16(data:int):void
		{
			for(var i:int = 0; i < 2; i++)
				arr.writeByte(data >> (8 * i));
		}
		public function WriteUInt32(data:uint):void
		{
			arr.writeUnsignedInt(data);
//			for(var i:int = 0; i < 4; i++)
//				arr.writeByte(data >> (8 * i));
		}
		public function WriteString(data:String):void
		{
			this.Write7BitEncodedInt(data.length);
			
			for(var i:int = 0; i < data.length;i++)
				WriteByte(data.charCodeAt(i));
		}
		public function WriteBoolean(data:Boolean):void
		{
			arr.writeBoolean(data);
		}
		public function WriteDouble(data:Number):void
		{
			arr.writeDouble(data);
		}
		public function WriteSingle(data:Number):void
		{
			arr.writeFloat(data);
		}
		public function WriteByte(data:int):void
		{
			arr.writeByte(data);
		}
		
		public function Write7BitEncodedInt(value:int):void
		{
		    var num:uint = uint(value);
		    while (num >= 0x80)
		    {
		        this.WriteByte(num | 0x80);
		        num = num >> 7;
		    }
		    this.WriteByte(num);
		}
	}
}