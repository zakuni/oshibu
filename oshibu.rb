# -*- coding: utf-8 -*-
require 'rubygems'
require 'appscript'
require 'eventmachine'
require 'socket'
require 'thread'
include Appscript
=begin
EM = EventMachine

EM::run do
  EM::defer do
    loop do
      puts 'a'
    end
  end
  
  EM::defer do
    loop do
      puts 'b'
    end
  end
  
end
=end

i = 0
channel = 100

def bookmark
  if app('Google Chrome.app').frontmost.get
    app('System Events').keystroke("d", :using => :command_down)
  else
    app('System Events').keystroke("t", :using => :shift_down)
  end
end

sensors = Array.new(4, 980) # センサーの番号と値を入れる配列

t = Thread.new do
  loop do
    sock = TCPSocket.open("127.0.0.1", 20000) # 127.0.0.1(localhost)の20000番へ接続

    ik = sock.read()
    sensor_and_value = ik.slice(/Sensor.*/)
    sensor = sensor_and_value.slice(/\d+/) # センサー番号
    value = /\d*:\s/.match(sensor_and_value).post_match # センサーの値

    sensors[sensor.to_i] = value.to_i
    
    sum = sensors[0] + sensors[2]
    distance = sensors[2] - sensors[0]

    puts "sensor0 = #{sensors[0]}, sensor2 = #{sensors[2]}, sum = #{sum}, distance = #{distance}"

    pressed = true
    if sensors[0] > 100
      puts "yeah"
      bookmark
    end

    if (pressed && 900 < distance)
      unless channel == 0
        channel = 0
        print("set channel", channel)
        i = 0
        while i < 5
            i += 1
        end
      end
    elsif (pressed && 200 < distance && distance < 900)
      unless channel == 1
        channel = 1
        puts ("set channel #{channel}")
        i = 0
        while i < 5
            i += 1
        end
      end
    elsif (pressed && -200 < distance && distance < 200)
      unless channel == 2
        channel = 2
        puts ("set channel #{channel}")
        i = 0
        while i < 5
            i += 1
        end
      end
    elsif (pressed && -900 < distance && distance < -200)
      unless channel == 3
        channel = 3
        puts ("set channel #{channel}")
        i = 0
        while i < 5
            i += 1
        end
      end
    elsif (pressed && distance < -900)
      unless channel == 4
        channel = 4
        puts ("set channel #{channel}")
        i = 0
        while i < 5
            i += 1
        end
      end
    end
    sleep(0.1)
  end
sock.close # ソケットを閉じる
end

t.join
