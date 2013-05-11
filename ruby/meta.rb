# some simple meta programming examples

class Class
  def my_macro(*splat)
    splat.each do |s|
      define_method(s.to_sym) do
        puts s
      end
    end
  end
end

class MyMetaExample
  my_macro :foo, :bar, :baz
end

class SomethingElse
  my_macro :blah
end

x = MyMetaExample.new
x.foo
x.bar
x.baz

y = SomethingElse.new
y.blah

class Missing
  def method_missing(method, *args, &block)
    puts "leave my #{method} alone bitch"
  end
end

m = Missing.new
m.foo
m.find_all_by_name