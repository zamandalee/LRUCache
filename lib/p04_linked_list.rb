class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @prev.next, @next.prev = @next, @prev
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Node.new("head")
    @tail = Node.new("tail")

    @head.next, @tail.prev = @tail, @head
  end

  def [](i)
    each_with_index { |node, idx| return node if i == idx }
    nil
  end

  def first
    @head.next unless empty?
  end

  def last
    @tail.prev unless empty?
  end

  def empty?
    !@head.next.val
  end

  def get(key)
    return nil unless include?(key)
    each { |node| return node.val if node.key == key }
    nil
  end

  def include?(key)
    return false if empty?

    each do |node|
      return true if node.key == key
    end

    false
  end

  def append(key, val)
    new_node = Node.new(key, val)
    new_node.prev = @tail.prev
    new_node.next = @tail

    @tail.prev.next = new_node
    @tail.prev = new_node
  end


  def update(key, val)
    return nil if empty?

    each do |node|
      node.val = val if node.key == key
    end
  end

  def remove(key)
    each do |node|
      node.remove if node.key == key
    end
  end

  def each(&block)
    current_node = @head.next

    until current_node == @tail
      block.call(current_node)
      current_node = current_node.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
