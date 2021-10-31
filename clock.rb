class Clock
    def initialize
      @counter = 0
    end
  
    def time(counter)
      "Время Лэмберта: #{counter}, Локальное время: #{Time.now}"
    end
  
    def recieve_timestamp(counter, timestamp)
      [timestamp, @counter].map(&:to_i).max + 1
    end
  
    def event(counter, process_id)
      puts "Что-то произошло в #{process_id}, #{time(counter)}"
      @counter += 1
    end
  
    def send_message(writer, counter, process_id)
      writer.write(counter)
      puts "Сообщение отправлено из процесса: #{process_id}, #{time(counter)}"
      @counter += 1
    end
  
    def recieve_message(reader, counter, process_id)
      puts "Сообщение получено в процессе: #{process_id}, #{time(counter)}"
      @counter
    end
  
    def process_one(read1, write1)
      pid = Process.pid
      counter = event(@counter, pid)
      counter = send_message(write1, counter, pid)
      write1.close
      counter = recieve_message(read1, counter, pid)
      "."
    end
  
    def process_two(read2, write1)
      pid = Process.pid
      counter = event(@counter, pid)
      counter = send_message(write1, counter, pid)
      write1.close
      counter = recieve_message(read2, counter, pid)
      "."
    end
  
    def process_three(read2, write2)
      pid = Process.pid
      counter = event(@counter, pid)
      counter = send_message(write2, counter, pid)
      write2.close
      counter = recieve_message(read2, counter, pid)
      "."
    end
  
    def perform
      read1, write1 = IO.pipe
      read2, write2 = IO.pipe
  
      process1 = fork do
        process_one(read1, write1)
      end
      process2 = fork do
        process_two(read2, write1)
      end
      process3 = fork do
        process_three(read2, write2)
      end
  
      Process.waitall
      exit!
    end
  end
  
  clock = Clock.new()
  clock.perform()