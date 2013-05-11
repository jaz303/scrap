# http://20bits.com/articles/introduction-to-dynamic-programming/

# input = [1, 5, -3, 4]
input = [1,2,-5,4,7,-2]

# i've no idea how to reproduce his python mojo
def naive(array)
  max = -10000
  for i in (0..array.length - 1)
    for j in (i..array.length - 1)
      total = array[i..j].inject { |m,k| m + k }
      max = total if total > max
    end
  end
  max
end

def optimised(array)
  
  bounds, max, curr, start = [0, 0], -10000, 0, 0
  
  array.each_with_index do |v, i|
    curr += v
    if curr > max
      max = curr
      bounds = [start, i]
    end
    if curr < 0
      curr = 0
      start = i + 1
    end
  end
  
  [max, bounds]

end

p naive(input)
p optimised(input)