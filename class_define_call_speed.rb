require 'benchmark/ips'

GC.disable

class Foo
  define_method("foo") { }
  class_eval 'def bar; end'
end

Benchmark.ips do |x|
  foo = Foo.new
  x.report("class_eval") { foo.bar }
  x.report("define_method") { foo.foo }
end