# only store integers from 0 to max inclusive
# set: item w boolean val
class MaxIntSet
  def initialize(max)
    @max = max
    @store = Array.new(max)
  end

  def insert(num)
    validate!(num)

    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num]
  end

  private
  def is_valid?(num)
    num.between?(0, @max)
  end

  def validate!(num)
    raise 'Out of bounds' unless is_valid?(num)
  end
end

# Each el is a subarray instead of boolean
class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    @store[num % num_buckets][num] = num
  end

  def remove(num)
    @store[num % num_buckets][num] = nil
  end

  def include?(num)
    !!@store[num % num_buckets][num]
  end

  private

  # def [](num)
  #   @store[num % num_buckets]
  # end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    unless include?(num)
      self[num] << num
      @count += 1
    end

    resize! if @count == @store.length
  end

  def remove(num)
    @count -= 1 if self[num].delete(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private
  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_set = ResizingIntSet.new(num_buckets * 2)

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
