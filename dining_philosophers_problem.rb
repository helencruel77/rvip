require 'thread'

class Philosopher
  def initialize(name, left_fork, right_fork)
    @philosopher_name = name
    @left_fork = left_fork
    @right_fork = right_fork
  end

  def run
    loop do
      think
    end
  end

  def think
    puts "Философ #{@philosopher_name} думает.."
    sleep(rand())
    eat
  end

  def eat
    loop do
      @left_fork.lock
      if @right_fork.try_lock
        break
      else
        @left_fork.unlock
      end
    end
    puts "Философ #{@philosopher_name} обедает.."
    sleep(rand())
    @left_fork.unlock
    @right_fork.unlock

    think
  end
end

n = 5

forks = []

(1..n).each { |i| forks << Mutex.new }

threads = []

(1..n).each do |i|
  threads << Thread.new do
    if i < n
      left_fork = forks[i]
      right_fork = forks[i-1]
    else
      left_fork = forks[0]
      right_fork = forks[1]
    end
    philosopher = Philosopher.new(i, left_fork, right_fork)
    philosopher.run
  end
end

threads.each { |thread| thread.join }