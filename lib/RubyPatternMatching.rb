require_relative 'RubyPatternMatching/Matchers'

class PatternFound < Exception
  attr_reader :return_value
  def initialize(return_value)
    @return_value = return_value
  end
end

class PatternNotFound < Exception
end

class Object
  def matches?(obj, &b)
    begin
      PatternMatching.new(obj).instance_eval &b
    rescue PatternFound => pf
        pf.return_value
    else
      raise PatternNotFound, "Reached end of pattern matching block"
    end
  end
end

class PatternMatching
  def initialize(obj)
    @obj = obj
  end

  def val(a_value)
    BasicMatcher.new { |obj| obj == a_value}
  end

  def type(a_type)
    BasicMatcher.new { |obj| obj.is_a? a_type}
  end

  def duck(*methods)
    BasicMatcher.new { |obj| methods.all? { |method| obj.respond_to? method} }
  end

  def list(a_list, size_matches = true)
    ListMatcher.new a_list, size_matches
  end

  def with(*matchers, &b)
    if matchers.all? { |matcher| matcher.call @obj }
      matchers.each { |matcher| matcher.do_bindings @obj, self }
      ret = self.instance_eval &b
      raise PatternFound.new(ret)
    end
  end

  def otherwise(&b)
    ret = self.instance_eval &b
    raise PatternFound.new(ret)
  end
end