#
# chomp

p "foo".chomp
p "foo\n".chomp
p "foo\n\n".chomp

#
# get local vars from binding (lambda)

fun = lambda do |x,y|
  a = x + y
  binding
end

result = fun.call(1,2)
p eval('local_variables', result)
p eval('a', result)

#
# get local vars from binding (method)

def foo(x, y)
  binding
end

result = foo(1, 2)
p eval('local_variables', foo(1,2))

#
# call stack

def bar
  p caller
end

bar

#
# tracing - can i get the method name?

def t1
  3.times { t2 }
end

def t2
  sleep 0.1
  4.times { |v| v % 2 > 0 ? t3 : t4 }
end

def t3
end

def t4
end

set_trace_func(Proc.new do |event, filename, line, object_id, binding, classname|
  puts "%s %s %s" % [event, line, classname]
end)

t1

set_trace_func(nil)

#
# throw/catch

def pitcher
  throw :halt
end

catch :halt do
  catch :wtf do
    puts "hi!"
    pitcher
    puts "shouldn't see me"
  end
  puts "shouldn't see me either"
end

#
# exit raises a SystemExit

begin
  exit 0
rescue SystemExit
  puts "I will not die"
end

#
# Display a message at the end

at_exit { puts "bye" }