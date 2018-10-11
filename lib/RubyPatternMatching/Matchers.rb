module Matcher
  def and(*matchers)
    matchers.push self
    AndMatcher.new matchers
  end

  def or(*matchers)
    matchers.push self
    OrMatcher.new matchers
  end

  def not
    NotMatcher.new self
  end
end

module ComplexMatcher
  include Matcher

  def initialize(children)
    @children = children
  end

  def do_bindings(obj, pttrn_mtc)
    @children.each { |child| child.do_bindings(obj, pttrn_mtc) if binding_condition(child, obj)}
  end
end


module BindingMatcher
  include Matcher

  def do_bindings(obj, pttrn_mtc)
    pttrn_mtc.define_singleton_method(bind_name) { obj }
  end
end

class AndMatcher
  include ComplexMatcher

  def call(obj)
    @children.all? { |child| child.call(obj) }
  end

  def binding_condition(_child, _obj)
    true
  end
end

class OrMatcher
  include ComplexMatcher

  def call(obj)
    @children.any? { |child| child.call(obj) }
  end

  def binding_condition(child, obj)
    child.call(obj)
  end
end

class NotMatcher
  include Matcher

  def initialize(child)
    @child = child
  end

  def call(obj)
    not @child.call(obj)
  end

  def do_bindings(obj, pttrn_mtc)
    @child.do_bindings obj, pttrn_mtc
  end
end

class ListMatcher
  include Matcher

  def initialize(patterns, size_matches)
    @patterns = patterns
    @size_matches = size_matches
  end

  def call(obj)
    obj.is_a? Array and (not @size_matches or @patterns.length == obj.length) and self.list_matches? obj
  end

  def do_bindings(list, pttrn_mtc)
    @patterns.each_with_index do |pattern, index|
      pattern.do_bindings(list[index], pttrn_mtc) if pattern.is_a? Matcher
    end
  end

  def list_matches?(list)
    index = -1
    @patterns.all? do |pattern|
      index += 1
      if list.length <= index
        true
      elsif pattern.is_a? Matcher
        pattern.call(list[index])
      else
        pattern == list[index]
      end
    end
  end
end

#Leaf classes
class BasicMatcher
  include Matcher

  def initialize(&block)
    @block = block
  end

  def call(obj)
    @block.call obj
  end

  def do_bindings(_obj, _pttrn_mtc)
  end
end


class Symbol
  include BindingMatcher

  def call(_obj)
    true
  end

  def bind_name
    self
  end

  def if (&condition)
    IfMatcher.new(self, &condition)
  end
end

class IfMatcher
  include BindingMatcher

  def initialize(name, &condition)
    @name = name
    @condition = condition
  end

  def call(obj)

    arity = @condition.arity
    begin
      if(arity == 1)
        obj.instance_exec obj, &@condition
      elsif (arity == 0)
        obj.instance_eval &@condition
      else
        raise ArgumentError, "expect 0 or 1, got #{arity}"
      end
    rescue NameError => name_error
      if(arity == 0)
        false
      else
        raise name_error
      end
    end
  end

  def bind_name
    @name
  end
end