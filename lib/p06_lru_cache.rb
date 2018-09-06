require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map[key]
      node = @map[key]
      update_node!(node)
      node.val
    else
      calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    val = @prc.call(key)
    new_node = @store.append(key, val) #  get val
    @map[key] = new_node # set val
    eject! if count > @max
    val
  end

  def update_node!(node)
    node.remove
    @map[node.key] = @store.append(node.key, node.val)
  end

  def eject!
    to_rm = @store[0]
    to_rm.remove
    @map.delete(to_rm.key)
    nil
  end
end
