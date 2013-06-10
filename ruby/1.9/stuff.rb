def named_captures
  regexp = /(?<number>\d+)/
  matches = "123".match(regexp)
  p matches[:number]
end

def default_args_at_beginning
  def foo(a = 1, b)
    p [a,b]
  end
  foo(3)
end

def assoc
  hsh = {a: 1, b: 2}
  p hsh.assoc(:b)
end

def splat
  def foo(a, *b, c)
    p [a,b,c]
  end
  foo(1,2,3,4,5)
end

def stabby_proc
  f = -> a,b { [a,b] }
  g = -> { 20 }
  p f.call(1,2)
  p g.call
end

def call_proc
  greet = -> subject { [:hello, subject] }
  p greet[:jason]
  p greet.call(:jason)
  p greet.(:jason)
  p greet === :jason
end

def string_iter
  p "foo".chars
  p "foo".bytes
  p "foo\nbar".bytes
  "foo".each_char { |c| puts c }
end

def lambda_args
  foo = -> a,b=2,*c { p [a,b,c] }
  foo.(1,2,3,4,5)
end

class Foo
end

def count_objects
  f = Foo.new
  p ObjectSpace.count_objects
end

def sample
  p [1,2,3,4,5].sample(2)
end

def block_locals
  v = 'foo'
  (1..9).map { |val; v| v = val }
  p v
end

def blocks_as_block_params
  b = -> v, &blk { blk.call(v + 5) }
  b.call(5) { |x| p x }
end

# def spawn
#   pid = spawn('echo hello')
#   p Process::waitpid2(pid)
# end

def json
  require 'json'
  h = {a: 1, b: 2}
  j(h)
  jj(h)
end

named_captures
default_args_at_beginning
assoc
splat
stabby_proc
call_proc
string_iter
lambda_args
count_objects
sample
block_locals
blocks_as_block_params
# spawn
json

# threads are real OS threads
# Process.daemon to daemonize current process
# MiniTest
# 

#
# Method owners

class Bar
  def foo
  end
end

class Baz
end

b = Baz.new
p b.method(:foo).owner

#
# Enumerators

enum = [1,2,3,4].map
p enum
enum.each { |v| p v }
enum.each { |v| p v }

fib = Enumerator.new do |y|
  a = b = 1
  loop do
    y.yield(a)
    a, b = b, a + b
  end
end

p fib.take(10)
p fib.take(10)

require 'fiber'

class MyEnumerator
  include Enumerable
  
  def initialize(obj, iterator_method)
    @f = Fiber.new do
      obj.send(iterator_method) do |*args|
        Fiber.yield(*args)
      end
      raise StopIteration
    end
  end
  
  def next
    @f.resume
  end
  
  def each
    loop { yield self.next }
  rescue StopIteration
    self
  end
end

enum = MyEnumerator.new([1,2,3,4], :each_with_index)
enum.each { |v,ix| p v }

#
# Fibers

$f1 = Fiber.new do |x|
  while x < 10
    p "f1: #{x}"
    x = $f2.resume(x + 2)
  end
end

$f2 = Fiber.new do |x|
  loop do
    p "f2: #{x}"
    x = Fiber.yield x-1
  end
end

$f1.resume(1)
