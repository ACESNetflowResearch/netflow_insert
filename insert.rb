#!/usr/bin/ruby

require 'mysql'

f = File.new("12_01.txt", "r")
#skip first line 
f.readline;
begin
    con = Mysql.new 'localhost', 'root', 'cyberaces', 'netflow_db'
    line_re = Regexp.new('(\d{4}\-\d{1,2}\-\d{1,2})\s(\d{1,2}\:\d{1,2}\:\d{1,2}\.\d{1,3})\s+(\d{1,3}\.\d{1,3})\s(\w+)\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)\s+\W+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)\s+(\.+[A-Z]*\.*[A-Z]*)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)')

    #    con.list_dbs.each do |db|
    #        puts db
    #    end
    f.each_line do |line| 
	   if line =~ line_re then

	   con.query("INSERT INTO `netflow_full` ( `date`, `duration`, `protocol`, `src_ip`, `src_port`, `dest_ip`, `dest_port`, `flags`, `tos`, `packets`, `bytes`, `pps`, `bps`, `bpp`, `flows`) 
		    VALUES (\'#{$1} #{$2}\', 
			   #{$3}, 
		    \"#{$4}\", 
		    INET_ATON(\"#{$5}\"), 
			   #{$6}, 
		    INET_ATON(\"#{$7}\"), 
			   #{$8}, 
		    \"#{$9}\", 
			   #{$10}, #{$11}, #{$12}, #{$13}, #{$14}, #{$15}, #{$16} );")
	   end
    end
rescue Mysql::Error => e
    puts e.errno
    puts e.error

ensure
    con.close if con
end
