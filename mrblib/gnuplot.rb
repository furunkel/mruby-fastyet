module Fastyet
  class Gnuplot
    def self.plot(data, output_filename)
      opts = "set terminal pdf;"
      opts += "set output '#{output_filename}';"
      line_opts = data.length.times.map do |i|
        "'-' index #{i} with linespoints ls 1"
      end.join(',')

      opts += "plot #{line_opts};"
      cmd = %Q{gnuplot -p -e "#{opts}"}
      IO.popen(cmd, 'w') do |p|
        data.each do |line|
          line.each do |x, y|
            p.puts "#{x} #{y}"
          end

          # start new line
          p.puts
          p.puts
        end

        p.puts "e"
      end
    end


  end
end
