require 'benchmark'

GC.disable

N = 100000
Benchmark.bm(13) do |x|
  x.report("define_method") {
    class Foo
      N.times { |i| define_method("foo_#{i}") { } }
    end
  }

  x.report("class_eval") {
    class Bar
      N.times { |i|
        class_eval <<-eoruby, __FILE__, __LINE__ + 1
          def bar_#{i}
          end
        eoruby
      }
    end
  }
end