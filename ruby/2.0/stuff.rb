def keyword_args
  def foo(bar, baz: "a", bleem: "b")
    puts "#{baz}>#{bar}<#{bleem}"
  end
  foo("raa")
  foo("raa", baz: "moose")
  foo("raa", baz: "boof", bleem: "basda")
end

def keyword_capture
  def foo(**opts)
    p opts
  end
  foo(a: "a", b: "b", c: "c")
  #foo("bleem", d: "hi", e: "bleh")
end

def symbol_literal
  p %i{foo bar baz}
end

class Foo
  def initialize
    @foo = 20
  end
  def bleep
    @foo
  end
end

class Bar
  def initialize
    @foo = 30
  end
end

def unbound
  # doesn't actually work
  #p Foo.instance_method(:bleep).bind(Object.new).call
end

class C1
  class C2
    FOO = 2
  end
end

def const_get_namespace
  p Object.const_get('C1::C2::FOO')
end

def to_h
  p({:foo => 1}.to_h)
  p nil.to_h
end

def encoding
  p "foo".encoding
  p "foo".b.encoding
end

keyword_args
keyword_capture
symbol_literal
unbound
const_get_namespace
to_h

warn "hi!"
encoding
p __dir__

# glob braces supported in File.fnmatch?
# can set stack sizes for threads/fibers at startup
# Thread.handle_interrupt and Thread.pending_interrupt? for controlling async cross-thread exceptions

# use define_method @ top level
define_method :foo do 
  puts "FOO"
end

foo