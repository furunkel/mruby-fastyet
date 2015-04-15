module Fastyet
  STEP = 0.05

  class << self

    def benchmark!(filename)
      data = []

      profiles = if RUN_NORMAL != RUN_JIT
        {:normal => RUN_NORMAL, :jit => RUN_JIT}
      else
        {:normal => RUN_NORMAL}
      end
      profiles.each do |name, flags|
        line = []
        0.2.step(1.0, STEP) do |n|
          result = run(filename, flags, n)
          line << result
        end
        data << line
      end
      Gnuplot.plot data, plot_filename(filename)
    end

    def plot_filename(bm_filename)
      bm_filename.sub('.rb', '.pdf')
              .sub("mrblib#{File::SEPARATOR}benchmark", 'plots')
    end

    def benchmark_dir!(dir)
      Dir.entries(dir).each do |f|
        if f[-3..-1] == '.rb'
          path = File.join dir, f
          benchmark! path
        end
      end
    end

    def start
      bm_dir = File.join File.dirname(__FILE__), 'benchmark'
      benchmark_dir! bm_dir
    end
  end
end

