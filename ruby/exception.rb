class StandardError
  
  module Priority1; end;
  module Priority2; end;
  module Priority3; end;

  def self.priority(priority)
    (1..priority).each { |p| include const_get("Priority#{p}") }
  end
  
end

#
# Handle error with same priority

class Foo < StandardError
  priority 2
end

begin
  raise Foo
rescue StandardError::Priority2
  puts "caught a Foo"
end

#
# High priority errors are also caught by rescuers with a lower threshold

class Baz < StandardError
  priority 3
end

begin
  raise Baz
rescue StandardError::Priority2
  puts "caught a Baz"
end

#
# This one will slip under the radar

class Bar < StandardError
  priority 1
end

begin
  begin
    raise Bar
  rescue Priority2
    puts "can't see me!"
  end
rescue
  puts "caught it..."
end
