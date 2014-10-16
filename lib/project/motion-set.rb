Set = NSMutableSet

class NSMutableSet
  include Enumerable

  def self.new(enum=nil)
    if enum
      enum.to_set
    else
      alloc.init
    end
  end

  def self.[](*ary)
    new.tap { |set| ary.each { |item| set.add item } }
  end

  def inspect
    "#<Set: {#{self.to_a.join ', '}}>"
  end

  def intersection(enum); send_to_copy(:'intersectSet', enum) end
  alias_method :&, :intersection

  def union(enum); send_to_copy(:'unionSet:', enum) end
  alias_method :|, :union
  alias_method :+, :union

  def difference(enum); send_to_copy(:'minusSet:', enum) end
  alias_method :-, :difference

  # Why can't you just: alias_method :add, :'addObject:'
  def add(o); addObject o end
  alias_method :<<, :add

  def ^(enum)
    ((self | enum) - (self & enum))
  end

  def add?(o)
    (include? o) ? nil : (add o)
  end

  def classify(&block)
    return to_enum(__method__) unless block_given?
    reduce({}) do |hash, item|
      classifier = block.call item
      hash[classifier] ||= Set[]
      hash[classifier].add item
      hash
    end
  end

  alias_method :clear, :removeAllObjects

  def collect!(&block)
    return to_enum(__method__) unless block_given?
    replace collect(&block)
  end
  alias_method :map!, :collect!

  # Why can't you just: alias_method :delete, :'removeObject:'
  def delete(o); removeObject o end

  def delete?(o)
    (include? o) ? (delete o) : nil
  end

  def keep_if(&block)
    return to_enum(__method__) unless block_given?
    each { |item| delete item unless block.call item }
    self
  end

  def delete_if(&block)
    return to_enum(__method__) unless block_given?
    each { |item| delete item if block.call item }
    self
  end

  # Why can't you just: alias_method :length, :count
  def length; count end
  alias_method :size, :length

  def empty?; count == 0 end

  def flatten
    self.to_enum(:flat_each).to_set
  end

  def flatten!
    copy = self.to_set
    # Not sure why self.to_enum does not work in this case:
    replace copy.to_enum :flat_each
    (copy == self) ? nil : self
  end

  alias_method :include?, :containsObject
  alias_method :member?, :containsObject

  def merge(enum)
    enum.each { |item| add item }
    self
  end

  def replace(enum)
    clear
    merge(enum)
  end

  def subtract(enum)
    enum.each { |item| delete item }
    self
  end

  def subset?(set)
    enforce_set(set) && isSubsetOfSet(set)
  end

  def superset?(set)
    enforce_set(set) && set.isSubsetOfSet(self)
  end

  def proper_subset?(set)
    (subset? set) && (self != set)
  end

  def proper_superset?(set)
    (superset? set) && (self != set)
  end

  def reject!(&block)
    return to_enum(__method__) unless block_given?
    each_returning_self_or_nil { |item| delete item if block.call item }
  end

  def select!(&block)
    return to_enum(__method__) unless block_given?
    each_returning_self_or_nil { |item| delete item unless block.call item }
  end

protected

  def flat_each(&block)
    each do |item|
      (item.instance_of? self.class) ? item.flat_each(&block) : block.(item)
    end
  end

private

  def each_returning_self_or_nil(&block)
    old_size = self.size
    each(&block)
    (old_size != size) ? self : nil
  end

  def enforce_set(set)
    raise ArgumentError, 'value must be a set' unless set.is_a? self.class
    true
  end

  def send_to_copy(symbol, enum)
    self.to_set.tap { |set| set.send(symbol, enum.to_set) }
  end

end

class Enumerable
  def to_set
    Set[*self]
  end
end
