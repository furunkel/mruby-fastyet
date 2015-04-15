module Fastyet
  class Gnuplot
    def self.plot(data, output_filename)
      opts = "set terminal pdf;"
      opts += "set output '#{output_filename}';"
      opts += "plot '-' with linespoints ls 1;"
      cmd = %Q{gnuplot -p -e "#{opts}"}
      IO.popen(cmd, 'w') do |p|
        data.each do |x, y|
          p.puts "#{x} #{y}"
        end

        p.puts "e"
      end
    end


  end
end
