package System
{
	public class TimeSpan
	{
		private var _totalMilliseconds : Number;
		
		public static var MaxValue:TimeSpan;
		
		public function TimeSpan(milliseconds : Number)
        {
            _totalMilliseconds = Math.floor(milliseconds);
        }
        
        public static function get Zero():TimeSpan
        {
        	return new TimeSpan(0);
        }
        
        public static function FromTicks(ticks:Number):TimeSpan
        {
        	return new TimeSpan(ticks);
        }
        
        public function get Ticks() : Number
        {
        	return _totalMilliseconds;
        }
		
        public function get Days() : int
        {
             return int(_totalMilliseconds / MILLISECONDS_IN_DAY);
        }
        public function get Hours() : int
        {
             return int(_totalMilliseconds / MILLISECONDS_IN_HOUR) % 24;
        }
        public function get Minutes() : int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_MINUTE) % 60; 
        }
        public function get Seconds() : int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_SECOND) % 60;
        }
        public function get Milliseconds() : int
        {
            return int(_totalMilliseconds) % 1000;
        }
        public function get TotalDays() : Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_DAY;
        }
        public function get TotalHours() : Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_HOUR;
        }
        public function get TotalMinutes() : Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_MINUTE;
        }
        public function get TotalSeconds() : Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_SECOND;
        }
        public function get TotalMilliseconds() : Number
        {
            return _totalMilliseconds;
        }
        public function Add(date : Date) : Date
        {
            var ret : Date = new Date(date.time);
            ret.milliseconds += TotalMilliseconds;

            return ret;
        }
        public static function FromDates(start : Date, end : Date) : TimeSpan
        {
            return new TimeSpan(end.time - start.time);
        }
        public static function FromMilliseconds(milliseconds : Number) : TimeSpan
        {
            return new TimeSpan(milliseconds);
        }
        public static function FromSeconds(seconds : Number) : TimeSpan
        {
            return new TimeSpan(seconds * MILLISECONDS_IN_SECOND);
        }
        public static function FromMinutes(minutes : Number) : TimeSpan
        {
            return new TimeSpan(minutes * MILLISECONDS_IN_MINUTE);
        }
        public static function FromHours(hours : Number) : TimeSpan
        {
            return new TimeSpan(hours * MILLISECONDS_IN_HOUR);
        }
        public static function FromDays(days : Number) : TimeSpan
        {
            return new TimeSpan(days * MILLISECONDS_IN_DAY);
        }

        public static const MILLISECONDS_IN_DAY : Number = 86400000;
        public static const MILLISECONDS_IN_HOUR : Number = 3600000;
        public static const MILLISECONDS_IN_MINUTE : Number = 60000;
        public static const MILLISECONDS_IN_SECOND : Number = 1000;
	}
	
	TimeSpan.MaxValue = new TimeSpan(9223372036854775807);
}