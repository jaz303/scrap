require 'test/unit'

# contexts for Test::Unit; just wanted to see how this stuff was done

class Test::Unit::TestCase
  def self.abstract_test!
    @abstract_test = true
  end
  
  def self.abstract_test?
    !! @abstract_test
  end
  
  def self.test(test_name, &block)
    define_method("test_#{test_name.to_s.gsub(/\s+/, '_')}", &block)
  end
  
  def self.todo(test_name, &block)
    # test("TODO_#{test_name}") { puts "TODO: #{test_name}" }
  end

  alias_method :default_test_without_abstract_support, :default_test
  def default_test
    return if self.class.abstract_test?
    default_test_without_abstract_support
  end
end

class Test::Unit::Context < Test::Unit::TestCase
  abstract_test!
  
  def setup
    self.class.run_blocks_in_context(self, :setup)
  end
  
  def teardown
    self.class.run_blocks_in_context(self, :teardown)
  end
  
  def __parent_context__
    self.class.instance_variable_get("@parent_context")
  end
  
  def self.run_blocks_in_context(context, symbol)
    @parent_context.run_blocks_in_context(context, symbol) if @parent_context
    hooks(symbol).each { |blk| context.instance_eval(&blk) }
  end
  
  def self.parent_context=(parent_context)
    @parent_context = parent_context
  end
  
  def self.setup(&block)
    add_hook(:setup, block)
  end
  
  def self.teardown(&block)
    add_hook(:teardown, block)
  end
  
  def self.add_hook(name, proc)
    hooks(name) << proc
  end
  
  def self.hooks(name)
    ((@hooks ||= {})[name] ||= [])
  end
end

module Test::Unit::ContextBuilder
  def context(name, &block)
    context = Class.new(::Test::Unit::Context, &block)
    if self.is_a?(Class) && ancestors.include?(::Test::Unit::Context)
      context.parent_context = self
    end
  end
end

include Test::Unit::ContextBuilder

context "foo" do
  setup do
    @bar = [1]
    @foo = 2
  end
  
  setup do
    @bar << 2
  end
  
  context "bar" do
    setup do
      @bar << 3
      @foo += 3
    end
    
    setup do
      @bar << 4
    end
    
    context "baz" do
      setup do
        @bar << 5
        @foo += 4
      end
      
      test "nested contexts should work" do
        assert_equal [1,2,3,4,5], @bar
        assert_equal 9, @foo
      end
    end
    
    test "contexts should work" do
      assert_equal [1,2,3,4], @bar
      assert_equal 5, @foo
    end
  end
  
  todo "test user must be older than 18"
  todo "check that a user can only register once"
  
  test "nothing" do
  end
  
end
