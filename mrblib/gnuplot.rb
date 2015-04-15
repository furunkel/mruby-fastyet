module Fastyet
  class Gnuplot
    def self.plot(data, output_filename)
      opts = "set terminal pdf;"
      opts += "set output '#{output_filename}';"
      line_opts = data.keys.map do |key|
        "'-' using 1:2 with linespoints title '#{key}'"
      end.join(',')

      opts += "plot #{line_opts};"
      cmd = %Q{gnuplot -p -e "#{opts}"}
      puts cmd
      IO.popen(cmd, 'w') do |p|
        data.each do |_, line|
          line.each do |x, y|
            p.puts "#{x} #{y}"
            puts "#{x} #{y}"
          end
          p.puts "e"
        end

      end
    end


  end
end
