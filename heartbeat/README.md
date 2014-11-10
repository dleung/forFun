# Heartbeat in Ruby

Heartbeat is an experimental attempt to write a multiple-forking process with monitoring.  

To use it, you create a Master Process that includes HeartBeatParent as a module.  Any of the spawned process include HeartBeatChild.  During execution, the parent process calls #spawn_and_perform and pass in a hash for the ChildProcess class instance to perform.

Motivation is for the master process to be able to create long-running child processes that the parent can monitor, like feed processing.  If the child process hangs, the master process can kill it and restart it with the same job parameters using heartbeat monitoring.  

Potentials:

1.  The ultimate idea is that if the child finishes sucessfully, it will send a signal back to the parent and the parents can have a callback to mark the process finished.  This would be ideal for batch processing, like having 10 children doing database writes in parallel with a finite connection pool.  
2.  Having a zero-downtime deploy will also be possible if we only kill the master process and let the children process finish during the deploy, and during restart it would create a new master process and spawn its own set of new children.  


```ruby
class MasterProcess
  include HeartBeatParent
end

class ChildProcess
  include HeartBeatChild

  def long_process(params)
    heartbeat_logger.info "Process: #{$$}\tParameters: #{params}"
    sleep 12
  end
end

f = MasterProcess.new

3.times do |i|
  params = i
  f.spawn_and_perform(ChildProcess, :long_process, params)
end

f.monitor
```


```
>> ruby heartbeat.rb
Parent (42381): New Thread Listening for Heartbeats
Parent (42381): New Thread Listening for Heartbeats
Process: 42406	Parameters: 0
Parent (42381): Checking All processes
Parent (42381): Monitoring complete.  Total Processes size: 3
Parent (42381): New Thread Listening for Heartbeats
Parent (42381): Child Heartbeat received	42406	active
Process: 42407	Parameters: 1
Parent (42381): Child Heartbeat received	42407	active
Parent (42381): Child Heartbeat received	42407	active
Process: 42408	Parameters: 2
Parent (42381): Child Heartbeat received	42408	active
Parent (42381): Child Heartbeat received	42408	active
Parent (42381): Child Heartbeat received	42406	active
Parent (42381): Child Heartbeat received	42407	active
Parent (42381): Child Process 42408 timeout reached and killed
Parent (42381): Child Heartbeat received	42406	active
Parent (42381): Child Heartbeat received	42407	active
Parent (42381): Child Heartbeat received	42407	active
Parent (42381): Child Heartbeat received	42406	active
Parent (42381): Checking All processes
Parent (42381): New Thread Listening for Heartbeats
Parent (42381): Spawning new child process from dead process
Parent (42381): Monitoring complete.  Total Processes size: 3
Parent (42381): Child Heartbeat received	42410	active
Process: 42410	Parameters: 2
Parent (42381): Child Heartbeat received	42407	active
Parent (42381): Child Heartbeat received	42406	active
Child (42406): Complete
Parent (42381): Child Heartbeat received		finished
Parent (42381): Child Heartbeat received		finished
Child (42407): Complete
Parent (42381): Child Heartbeat received	42410	active
Parent (42381): Child Heartbeat received	42410	active
Parent (42381): Child Heartbeat received	42410	active
Parent (42381): Child Heartbeat received	42410	active
Parent (42381): Checking All processes
Parent (42381): Monitoring complete.  Total Processes size: 1
Child (42410): Complete
Parent (42381): Child Heartbeat received		finished
Parent (42381): Checking All processes
Parent (42381): Monitoring complete.  Total Processes size: 0

# Timeout is achieved when rand(6) > 5 in this example.  Uncomment Line 33
```