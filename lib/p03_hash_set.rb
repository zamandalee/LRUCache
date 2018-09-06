require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    unless include?(key)
      self[key.hash] << key
      @count += 1
    end

    resize! if @count == @store.length
  end

  def include?(key)
    self[key.hash].include?(key)
  end

  def remove(key)
    @count -= 1 if self[key.hash].delete(key)
  end

  private

  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_set = HashSet.new(num_buckets * 2)

    @store.each do |bucket|
      bucket.each do |el|
        new_set.insert(el)
      end
    end

    @store = new_set.store
  end

  protected
  attr_reader :store
end
