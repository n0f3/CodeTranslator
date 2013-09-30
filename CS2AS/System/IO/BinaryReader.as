package System.IO
{
	import System.Text.StringBuilder;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class BinaryReader
	{
		public var arr:ByteArray;
		
		public function BinaryReader(readFrom:ByteArray)
		{
			arr = readFrom;
			arr.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function Read7BitEncodedInt():int
		{
			var num3:int;
			var num:int = 0;
			var num2:int = 0;
			do
			{
			    if (num2 == 0x23)
			        throw new Error("Bad format");
			        
			    num3 = this.ReadByte();
			    num |= (num3 & 0x7f) << num2;
			    num2 += 7;
			}
			while ((num3 & 0x80) != 0);
			return num;
		}

		
		public function ReadBytes(num:uint):ByteArray
		{
			var ret:ByteArray = new ByteArray();
			while (num > 0)
			{
				ret.writeByte(this.ReadByte());
				num--;
			}
			return ret;
		}
		
		public function ReadInt64():Number
		{
			var buf:Array = [ this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte(), this.ReadByte() ];
			
			var num:Number = (uint) (((buf[0] | (buf[1] << 8)) | (buf[2] << 0x10)) | (buf[3] << 0x18));
    		var num2:Number = (uint) (((buf[4] | (buf[5] << 8)) | (buf[6] << 0x10)) | (buf[7] << 0x18));
    		return ((num2 << 0x20) | num);
		}
		public function ReadInt32():int
		{
			return arr.readInt();
//			var b0:int = this.ReadByte();
//			var b1:int = this.ReadByte();
//			var b2:int = this.ReadByte();
//			var b3:int = this.ReadByte();
//			return (((b0 | (b1 << 8)) | (b2 << 0x10)) | (b3 << 0x18));
		}
		public function ReadUInt16():int
		{
			return arr.readUnsignedShort();
		}
		public function ReadInt16():int
		{
			return arr.readShort();
		}
		public function ReadUInt32():uint
		{
			return arr.readUnsignedInt();
		}
		public function ReadString():String
		{
			var length:int = Read7BitEncodedInt();
			
			if (length == 0)
				return "";
				
			var sb:StringBuilder = new StringBuilder();
			
			for(var i:int = 0; i < length; i++)
				sb.AppendChar(this.ReadByte());
			return sb.toString();
		}
		public function ReadBoolean():Boolean
		{
			return arr.readBoolean();
		}
		public function ReadDouble():Number
		{
			return arr.readDouble();
		}
		public function ReadSingle():Number
		{
			return arr.readFloat();
		}
		public function ReadByte():int
		{
			return arr.readUnsignedByte();
		}
	}
}