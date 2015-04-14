module Fastyet
  def self.start
    bm_dir = File.join File.dirname(__FILE__), 'benchmark'
    Dir.entries(bm_dir).each do |f|
      if f[-3..-1] == '.rb'
        path = File.join bm_dir, f
        10.step(10000, 100) do |n|
          p run(path, n)
        end
      end
    end
  end
end

