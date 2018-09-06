# LRUCache

## Phase 1: IntSet

- **Set**: data type that can store unordered, unique items
  - Very fast retrieval/lookup time
- A set is an **abstract data type**: a high-level description of a structure and an API (i.e., a specific set of methods)
  - Ex.: sets, maps, or queues
- Any given data type or API can be implemented with **data structures**

### MaxIntSet
- Stores integers that live in a predefined range

```rb
  def initialize(max)
  @max = max
  @store = Array.new(max)
  end
```
- ```@store```: constant size
  - Each index in the `@store` will correspond to an item, and the value
    at that index will correspond to its presence (either `true` or
    `false`)
  - e.g., the set `{ 0, 2, 3 }` will be stored as: `[true, false, true,
    true]`
- Methods:
  - `#insert`
  - `#remove`
  - `#include?`

### IntSet
- Stores arbitrary range of integers.

```rb
  def initialize(num_buckets = 20)
     @store = Array.new(num_buckets) { Array.new }
  end
```
- @store initialized to fixed length, but each element is a subarray
- Insertion: `idx = num % num_buckets`
  - `#[](val)` so can call `self[num]`, which is more DRY than `@store[num % num_buckets]`

### ResizingIntSet
```rb
def initialize(num_buckets = 20)
  @store = Array.new(num_buckets) { Array.new }
  @count = 0 # increment for insertion, decrement for removal
end

# ...

def resize!
  new_set = ResizingIntSet.new(num_buckets * 2)

  @store.each do |bucket|
    bucket.each do |el|
      new_set.insert(el)
    end
  end

  @store = new_set.store
end
```

The IntSet's retrieval time depends on an array scan, which is worst case O(n) time — far too slow. We're doing an array scan on one of the 20 buckets, that bucket will have on average 1/20th of the overall items. This simplifies to `O(n)`. Meh.

## Phase 2: Hashing

- Hash function is a sequence of mathematical operations that
deterministically maps any arbitrary data into a pre-defined range of
values
  - Good hash function: uniform in how it distributes data, able to hash absolutely
anything, is deterministic (always produce the same value given the same input)

## Phase 3: HashSet

Now that there are hashing functions, any data type can be stored in the set.

This will be a simple improvement on ResizingIntSet. Just hash every
item before performing any operation on it.

## Phase 4: Node and Linked List

- Linked list: a data structure of a series of nodes
  - Node: holds a key, value, and pointer to the next node (or `nil`)
  - Given a pointer to the first (or head) node, you can access any arbitrary node by traversing the nodes in order
- Doubly linked list: each node has pointer to the previous node, too
  - Given a pointer to the last (or tail) node, we can traverse the list in reverse order

LinkedLists will ultimately be used in lieu of arrays for our HashMap buckets

- Sentinel node: "dummy" node that does not hold a value, used for head and tail
  - H and T should never be reassigned.

- Methods:
  - `first`
  - `empty?`
  - `#append(key, val)` - Append a new node to the end of the list.
  - `#update(key, val)` - Find an existing node by key and update its value.
  - `#get(key)`
  - `#include?(key)`
  - `#remove(key)`

## Phase 5: Hash Map
- Instead of Arrays,`LinkedLists` used for buckets

```rb
def initialize(num_buckets = 8)
  @store = Array.new(num_buckets) { LinkedList.new }
  @count = 0
end
```

## Phase 6: LRU Cache

Time to upgrade the hash map to make an LRU Cache!
- Least Recently Used Cache: of the `n`most-recently-used items
  - Could be web pages, objects in memory on a video game, etc.

Basic Principles:
- Cache will only hold `max` many items (set `max` upon initialize)
- For retrieval and insertion, mark that item as now
  being the most recently used item
- If the cache exceeds size `max` upon insertion, delete the
  least recently used item

Consists of:
![](lru-cache-scaled500.png?raw=true)

- Linked list: each node holds a cached object
  - Nodes at the end will always be freshest, while those at the beginning
are oldest
  - Only problem is lookup time, bc linked lists are slow O(n)
- Hash map: keys are same keys in linked list, but won't store the values associated, just point to node object in linked list* (if it exists)
  - Upon insertion or deletion in LRU Cache, do the same in hash in O(1) time

Details:
- Each time new key-value pair added to cache:
  1. See if the key points to node in hash map.
    - If it does, item exists in cache -> move node to the very
    end of the list (most recently used item) -> return item
    - Isn't in hash map -> isn't in cache ->
      - Call the proc with key as input -> output is key's value
      - Append key-value pair to the linked list (most recently used item)
      - Add the key to hash, along with pointer to
        the new node
      - If the cache has exceeded its `max` size, call `eject!`, which deletes LRU (first item)

## Phase 7: Practical Problem
Write a method to test whether the letters forming  a string can be
permuted to form a palindrome. For example, "edified" can be permute to form
"deified".
