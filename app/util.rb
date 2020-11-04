def try_to(description, &block)
  (0..1000).each do |timeout|
    result = yield
    return result if result
  end
  raise "Timeout while trying to #{description}"
end

def random_range(min, max)
  (rand * (max - min + 1)).floor + 1
end

def shuffle(array)
  r = nil
  (0..array.length).each do |i|
    r = random_range(0, i)
    array[i], array[r] = array[r], array[i]
  end
  array
end
