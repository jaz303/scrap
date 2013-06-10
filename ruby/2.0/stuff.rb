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

keyword_args
keyword_capture
symbol_literal
unbound