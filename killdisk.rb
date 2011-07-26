#!/usr/bin/env ruby1.9.1

watchdisks = [ 'sda', 'sdb', 'sdd', 'sde', ]

class Disk
	attr :name, :last_activity

	def initialize(name)
		@name = name
		@reads = @writes = 0
		self.last_activity
	end

	def awake?
		state = nil
		status = `hdparm -C /dev/#{@name}`
		status.each_line do |line|
			state = /drive state is:\s+([^\s]+)/.match(line)
			break if state
		end
		raise "Didn't get state!" unless state
		state[1] == 'active/idle' ? true : false
	end

	def sleep!
		`hdparm -y /dev/#{@name}`
	end

	def last_activity
		reads, writes = self.get_counters
		if reads.to_i > @reads.to_i
			@reads = reads
			@last_activity = Time.now
		end
		
		if writes.to_i > @writes.to_i
			@writes = writes
			@last_activity = Time.now
		end
		@last_activity
	end

	def get_counters
		File.open('/proc/diskstats') do |f|
			fields = nil
			f.each_line do |line|
				fields = line.split(/\s+/)
				break if fields[3] == @name
				fields = nil
			end
			raise "Couldn't find device" unless fields
			[fields[4], fields[8]]
		end
	end
end

watchdisks.map! do |disk|
	disk = Disk.new(disk)
end

while true
	watchdisks.each do |disk|
		next unless disk.awake?
		if Time.now > disk.last_activity + 60 * 30
			puts "#{Time.now}: Putting #{disk.name} to sleep, last activity was at #{last.activity}"
			disk.sleep!
		end
	end
	sleep 300
end
