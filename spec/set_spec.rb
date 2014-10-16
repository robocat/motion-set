#require_relative '../app/set.rb'

describe 'Set' do
  def test(description, &block); it(description, &block) end

  it 'can be constructed with #[]' do
    reference = NSMutableSet.new
    reference.addObject 1
    reference.addObject 2
    reference.addObject 3
    Set[1, 2, 3].should == reference
  end

  it 'can be constructed to be empty' do
    Set.new.should == Set[]
  end

  it 'can be constructed from enumerables' do
    Set.new([1, 2, 3]).should == Set[1, 2, 3]
    [1, 2, 3].to_set.should == Set[1, 2, 3]
    {a: 1, b: 2}.to_set.should == Set[[:a, 1], [:b, 2]]
  end

  it 'can find intersecting set' do
    original = Set[1, 2, 3]
    original.intersection([2, 3, 4]).should == Set[2, 3]
    original.should == Set[1, 2, 3]
  end

  it 'can find union set' do
    Set[1, 2].union(Set[2, 3]).should == Set[1, 2, 3]
  end

  it 'can find set difference' do
    Set[1, 2, 3, 4].difference([2, 3]).should == Set[1, 4]
  end

  it 'can add objects' do
    set = Set.new
    set.add 1
    set << 2
    set.should == Set[1, 2]
  end

  it 'can find exclusive elements' do
    (Set[1, 2, 3] ^ Set[2, 3, 4]).should == Set[1, 4]
  end

  it 'can #add? new element' do
    set = Set[1, 2]
    (set.add? 3).should.equal? set
    set.should == Set[1, 2, 3]
  end

  it 'can #add? existing element' do
    set = Set[1, 2]
    (set.add? 2).should.equal? nil
    set.should == Set[1, 2]
  end

  it 'can #inspect correctly' do
    Set[1, 2].inspect.should == '#<Set: {1, 2}>'
    # TODO nested sets
  end

  describe '#classify' do
    should 'classify itself' do
      hash = Set[1, 2, 3, 4].classify { |n| n.odd? ? :odd : :even }
      hash.should == {odd: Set[1, 3], even: Set[2, 4]}
    end

    should 'returns an enumerator when called without block' do
      set = Set[1, 2, 3, 4]
      enumerator = set.classify
      enumerator.to_set.should == Set[1, 2, 3, 4]
      set.should == Set[1, 2, 3, 4]
    end
  end

  it 'can #clear itself' do
    set = Set[1, 2, 3]
    set.clear.should == Set[]
    set.should == Set[]
  end

  describe '#collect!' do
    should 'map over itself' do
      set = Set[1, 2, 3]
      set.collect! { |item| item * 10 }.should == Set[10, 20, 30]
      set.should == Set[10, 20, 30]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.collect!
      enumerator.each { 42 }.to_set.should == Set[42]
      set.should == Set[42]
    end
  end

  it 'can #delete an item from itself' do
    set = Set[1, 2, 3]
    set.delete(2).should == Set[1, 3]
    set.should == Set[1, 3]
  end

  it 'can #delete? when object is present' do
    set = Set[1, 2, 3]
    set.delete?(2).should == Set[1, 3]
    set.should == Set[1, 3]
  end

  it 'can #delete? when object is absent' do
    set = Set[1, 2, 3]
    set.delete?(9).should == nil
    set.should == Set[1, 2, 3]
  end

  describe '#keep_if' do
    should 'return modified self' do
      set = Set[1, 2, 3, 4]
      set.should.equal? set.keep_if { |item| item.odd? }
      set.should == Set[1, 3]
    end

    should 'return enumerator which consumes the set' do
      set = Set[1, 2, 3]
      enumerator = set.keep_if
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[]
    end
  end

  describe '#delete_if' do
    should 'return modified self' do
      set = Set[1, 2, 3, 4]
      set.delete_if { |item| item.odd? }
      set.should == Set[2, 4]
    end

    should 'return enumerator which does *not* consume the set' do
      set = Set[1, 2, 3]
      enumerator = set.delete_if
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[1, 2, 3]
    end
  end

  it 'has #length' do
    Set[1, 2, 3].length.should == 3
  end

  # TODO #devide

  it 'has #each' do
    set = Set[]
    Set[1, 2, 3].each { |item| set << item }
    set.should == Set[1, 2, 3]
  end

  test '#empty?' do
    Set[].empty?.should == true
    Set[1].empty?.should == false
  end

  describe '#flatten' do
    should 'return a flattened set' do
      Set[1, 2, Set[3, Set[4]], 5].flatten.should == Set[1, 2, 3, 4, 5]
    end

    should 'not modifie the original set' do
      set = Set[1, 2, Set[3, Set[4]], 5]
      set.flatten
      set.should == Set[1, 2, Set[3, Set[4]], 5]
    end
  end

  describe '#flatten!' do
    should 'flatten the set in-place' do
      set = Set[1, 2, Set[3, Set[4]], 5]
      set.flatten!.should.equal? set
      set.should == Set[1, 2, 3, 4, 5]
    end

    should 'not flatten an already flat set' do
      set = Set[1, 2, 3]
      set.flatten!
      set.should == Set[1, 2, 3]
    end

    should 'return nil if no modification is made' do
      set = Set[1, 2, 3]
      set.flatten!.should == nil
    end
  end

  test '#include? #member?' do
    Set[1, 2].include?(2).should == true
    Set[1, 2].member?(9).should == false
  end

  test '#merge' do
    set = Set[1, 2, 3]
    set.merge([3, 4, 5]).should.equal? set
    set.should == Set[1, 2, 3, 4, 5]
  end

  test '#subset?' do
    a = Set[1, 2]
    a.subset?(a).should == true
    a.subset?(Set[1, 2, 3]).should == true
    should.raise(ArgumentError) { a.subset?([1, 2, 3]) }
  end

  test '#superset?' do
    a = Set[1, 2, 3]
    a.superset?(a).should == true
    a.superset?(Set[1, 2]).should == true
    should.raise(ArgumentError) { a.superset?([1, 2]) }
  end

  test '#proper_subset?' do
    a = Set[1, 2]
    a.proper_subset?(a).should == false
    a.proper_subset?(Set[1, 2, 3]).should == true
    should.raise(ArgumentError) { a.proper_subset?([1, 2, 3]) }
  end

  test '#proper_superset?' do
    a = Set[1, 2, 3]
    a.proper_superset?(a).should == false
    a.proper_superset?(Set[1, 2]).should == true
    should.raise(ArgumentError) { a.proper_superset?([1, 2]) }
  end

  describe '#reject!' do
    should 'return self when changes are made' do
      set = Set[1, 2, 3]
      set.should.equal? set.reject! { |item| item.even? }
      set.should == Set[1, 3]
    end

    should 'return nil when *no* chages are made' do
      set = Set[1, 2, 3]
      nil.should == set.reject! { |item| item == 42 }
      set.should == Set[1, 2, 3]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.reject!
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[1, 2, 3]
    end
  end

  describe '#select!' do
    should 'return self when changes are made' do
      set = Set[1, 2, 3]
      set.should.equal? set.select! { |item| item.odd? }
      set.should == Set[1, 3]
    end

    should 'return nil when *no* chages are made' do
      set = Set[1, 2, 3]
      nil.should == set.select! { |item| item < 42 }
      set.should == Set[1, 2, 3]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.select!
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[]
    end
  end




  test '#replace' do
    set = Set[1, 2, 3]
    set.replace([7, 8, 9]).should.equal? set
    set.should == Set[7, 8, 9]
  end

  test '#subtract' do
    set = Set[1, 2, 3]
    set.subtract([2, 4]).should.equal? set
    set.should == Set[1, 3]
  end

  test '#to_a (implemented by Enumerable)' do
    set = Set[1, 2, 3]
    array = set.to_a
    array.class.should == Array
    array.to_set.should == set
  end
end
