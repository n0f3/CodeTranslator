package System
{
	public class DateTime
	{
		private var date:Date;
		
		public function DateTime(ticks:Number = -5)
		{
			date = new Date();
			
			if (ticks != -5)
				date.time = ticks;
		}
		
		public function get Ticks():Number
		{
			return date.time;
		}
		
		public static function get Now():DateTime 
		{
			return new DateTime();
		}
		
		public function Subtract(other:DateTime):TimeSpan
		{
			return new TimeSpan(date.time - other.date.time);
		}

		public static function get MinValue():DateTime
		{
			return new DateTime(0);
		}
		
		public static function get MaxValue():DateTime
		{
			return new DateTime(3155378975999999999);
		}
	}
}