def naive_tour(a, x, y, total)
  
  return true if total == a.length
  
  size = Math.sqrt(a.length)
  return false if x >= size || x < 0 || y >= size || y < 0
  
  index = y * size + x
  return false if a[index]
  
  a[index] = true
  
  [ [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2], [1,2] ].each do |mv|
    if naive_tour(a.dup, x + mv[0], y + mv[1], total + 1)
      puts "#{x} #{y}"
      return true
    end
  end
  
  return false

end

# see you next year
naive_tour(Array.new(64), 0, 0, 0)