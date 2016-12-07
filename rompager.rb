#!/usr/bin/env ruby

require 'rubygems'
require 'colorize'

def verComp(ver1,ver2)
	v1 = ver1.split(".")
	v2 = ver2.split(".")

	(0..v1.size).each do |v|
		v1[v] = v1[v].to_i
	end

	(0..v2.size).each do |v|
		v2[v] = v2[v].to_i
	end

	if v1.length < v2.length
		v1.fill(0,v1.find_index(v1[-1]),v2.size)
	end
	if v1.length > v2.length
		v2.fill(0,v2.find_index(v2[-1]),v1.size)
	end

	(0..v1.size).each do |i|
		if v1[i] > v2[i]
			return 1
		end
		if v1[i] < v2[i]
			return -1
		end
	end

	return 0
end

if ARGV[0].nil?
	raise "Need an input IP or hostname"
end
if ARGV[1].nil?
	raise "Need an port numnber"
end
 
output = %x{/usr/bin/curl --head -s http://#{ARGV[0]}:#{ARGV[1]}}

ver = 0
if output =~ /RomPager\/(\d\.\d+)/
	ver = $1
end

puts "RomPager version #{ver} found."
if verComp(ver, "4.34") === -1
	puts "Vulnerable to CVE-2014-9222 misfortune cookie".red
end

if verComp(ver, "4.51") === -1 
	puts "Vulnerable to CVE-2013-6786 XSS".yellow
end

if verComp(ver, "2.20") === -1
	puts "Vulnerable to CVE-2000-0470".yellow
end

if verComp(ver, "4.50") === 1
	puts "Not vulnerable to known issues".green
end

