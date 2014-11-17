#!/usr/bin/ruby

require 'mysql'

f = File.new("12_01.txt", "r")
#skip first line 
f.readline;
begin
    con = Mysql.new 'localhost', 'root', 'cyberaces', 'netflow_db'
    line_re = Regexp.new('(\d{4}\-\d{1,2}\-\d{1,2})\s(\d{1,2}\:\d{1,2}\:\d{1,2}\.\d{1,3})\s+(\d{1,3}\.\d{1,3})\s(\w+)\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)\s+\W+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)\s+(\.+[A-Z]*\.*[A-Z]*)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)')

	   is_first = true;
	   count = 0;
	   values = "";

	   f.each_slice(1000) do |lines| 
		  lines.each do |line|
			 if line =~ line_re then
				#handle if there should be a comma between values or not
				if !is_first then values.concat ", " else is_first = false end
				values.concat "(\'#{$1} #{$2}\', 
				#{$3}, 
		    \"#{$4}\", 
		    INET_ATON(\"#{$5}\"), 
				#{$6}, 
		    INET_ATON(\"#{$7}\"), 
				#{$8}, 
		    \"#{$9}\", 
				#{$10}, #{$11}, #{$12}, #{$13}, #{$14}, #{$15}, #{$16} ) "
			 end
		  end

		  count = count + 1;
		  #every 101 records, write to database
		  puts "inserted line number #{count * 1000} to database"
		  query =  "INSERT INTO `netflow_full_2` ( `date`, `duration`, `protocol`, `src_ip`, `src_port`, `dest_ip`, `dest_port`, `flags`, `tos`, `packets`, `bytes`, `pps`, `bps`, `bpp`, `flows`) VALUES " + values + ";" 
		  #puts query;
		  con.query(query);
		  #reset values 
		  values = "";
		  is_first = true;
	   end
rescue Mysql::Error => e
    puts e.errno
    puts e.error

ensure
    con.close if con
end
