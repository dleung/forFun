require 'logger'
require 'timeout'

module HeartBeatStruct
  # Structure for information exchange between
  # Parent and Child Processes
  Heartbeat = Struct.new(:timestamp, :pid, :status)
end

module HeartBeatLogger
  def heartbeat_logger
    @heartbeat_logger ||= Logger.new(STDOUT)
  end
end

module HeartBeatChild
  include HeartBeatStruct
  include HeartBeatLogger
  attr_reader :threads

  # Sends a heartbeat every I
  HEARTBEAT_INTERVAL = 3

  # Starts a beating pulse that notifies the parent
  # every few seconds to notify that it is alive
  def start_heartbeat(heartbeat_writer)
    @threads ||= []
    @threads << Thread.new do
      loop do
        heartbeat = Heartbeat.new(Time.now, $$, :active)
        heartbeat_writer.puts(Marshal.dump(heartbeat))

        # uncomment to test occasional timeout and automatic respawning of child process
        # sleep rand(6)
        sleep HEARTBEAT_INTERVAL
      end
    end
  end

  def cleanup(heartbeat_writer)
    heartbeat = Heartbeat.new(Time.now, @pid, :finished)
    heartbeat_writer.write(Marshal.dump(heartbeat))
    heartbeat_writer.close
    @threads.each {|t| Thread.kill t}

    heartbeat_logger.info("Child (#{$$}): Complete")
  end
end

module HeartBeatParent
  include HeartBeatStruct
  include HeartBeatLogger

  def spawn_and_perform(klass, method, params)
    @processes ||= {}
    heartbeat_reader, heartbeat_writer = IO.pipe

    pid = fork do
      heartbeat_reader.close

      cp = klass.new
      cp.start_heartbeat(heartbeat_writer)
      cp.send(method, *params)
      cp.cleanup(heartbeat_writer)
    end

    @processes[pid.to_s] = {
        last_polled: Time.now,
        status: :created,
        klass: klass,
        method: method,
        params: params
      }

    heartbeat_writer.close

    monitor_heartbeat(pid, heartbeat_reader)
  end

  def monitor
    loop do
      heartbeat_logger.info "Parent (#{$$}): Checking All processes"
      dead_processes = []
      finished_processes = []

      @processes.each do |pid, process|
        if [:killed, :dead].include?(process[:status])
          dead_processes << pid
        elsif [:finished].include?(process[:status])
          finished_processes << pid
        end
      end

      dead_processes.each do |pid|
        dead_process = @processes[pid]

        spawn_and_perform(dead_process[:klass], dead_process[:method], dead_process[:params])
        @processes.delete(pid)
        heartbeat_logger.warn "Parent (#{$$}): Spawning new child process from dead process"
      end

      finished_processes.each do |pid|
        @processes.delete(pid)
      end

      heartbeat_logger.info "Parent (#{$$}): Monitoring complete.  Total Processes size: #{@processes.size}"
      sleep 10
    end
  end

  HEARTBEAT_TIMEOUT = 5
  def monitor_heartbeat(pid, heartbeat_reader)
    Thread.new do
      Process.wait(pid)
    end

    begin
      Thread.new do
        heartbeat_logger.info "Parent (#{$$}): New Thread Listening for Heartbeats"
        loop do

          data = begin
            Timeout::timeout(HEARTBEAT_TIMEOUT) do
              heartbeat_reader.gets
            end

          rescue Timeout::Error
            heartbeat_logger.warn "Parent (#{$$}): Child Process #{pid} timeout reached and killed"
            Process.kill("TERM", pid)
            @processes[pid.to_s].merge!({
              last_polled: Time.now,
              status: :killed
            })
            Thread.current.exit
          end

          if data.nil?
            heartbeat_logger.warn "Parent (#{$$}): #{pid} Process died"
            @processes[pid.to_s].merge!({
              last_polled: Time.now,
              status: :dead
            })

            Thread.current.exit
          end

          heartbeat = Marshal.load(data)

          heartbeat_logger.info "Parent (#{$$}): Child Heartbeat received\t#{heartbeat.pid}\t#{heartbeat.status}"

          @processes[pid.to_s].merge!({
            last_polled: heartbeat.timestamp,
            status: heartbeat.status
          })

          if heartbeat.status == :finished
            Thread.current.exit
          end
        end
      end

    rescue ArgumentError => e
      raise unless e.message.match("marshal data too short")
      heartbeat_logger.warn "Parent (#{$$}): Retrying Marshal"
      retry
    rescue => e
      heartbeat_logger.error "Parent (#{$$}): #{e.message}"
      heartbeat_logger.error "Parent (#{$$}): #{e.backtrace}"
    end
  end
end

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