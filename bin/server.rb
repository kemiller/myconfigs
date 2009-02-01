#!/usr/bin/env ruby
require 'socket'

s = TCPServer.new 8888
loop {
	c = s.accept
	c << "\n" + IO.read(c.gets[/\/(.*) /,1].gsub(/\.{2,}/){}) rescue 404
	c.close
}
