#!/usr/bin/ruby

require 'mysql'

begin
    con = Mysql.new 'localhost', 'root', 'cyberaces', 'netflow_db'

#    con.list_dbs.each do |db|
#        puts db
#    end 
    con.query("INSERT INTO `netflow` ( `date`, `duration`, `protocol`, `src_IP`, `dest_IP`, `flags`, `Tos`, `packets`, `bytes`, `pps`, `bps`, `Bpp`, `Flows`) VALUES (\"2013-12-01 06:06:45.743\", \"0.000\", \"UDP\", \"184.247.195.108:53375\", \"166.174.46.166:8471\", \"......\", \"0\", 1, 44, 0, 0, 44, 2 );")
 
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end
