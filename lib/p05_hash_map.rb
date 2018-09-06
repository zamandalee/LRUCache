require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key.hash).include?(key)
  end

  def set(key, val)
    unless include?(key)
      @count += 1
      resize! if @count == num_buckets
      bucket(key.hash).append(key, val)
    else
      bucket(key.hash).update(key, val)
    end
  end

  def get(key)
    bucket(key.hash).get(key)
  end

  def delete(key)
    if include?(key)
      bucket(key.hash).remove(key)
      @count -= 1
    end
  end

  def each(&prc)
    @store.each do |bucket|
      bucket.each do |node|
        prc.call(node.key, node.val)
      end
    end

  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_buckets = num_buckets * 2

    temp = HashMap.new(new_buckets)
    each do |key, val|
      temp.set(key, val)
    end
    @store = temp.store
  end

  def bucket(key)
    @store[key.hash % num_buckets]
  end

  protected
  attr_reader :store
end
