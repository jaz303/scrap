
def Math.max(a, b)
  a > b ? a : b
end

items = [
  {:weight => 5, :value => 100},
  {:weight => 7, :value => 200},
  {:weight => 4, :value => 150},
  {:weight => 5, :value => 150},
  {:weight => 6, :value => 120},
  {:weight => 1, :value => 100},
  {:weight => 1, :value => 100},
  {:weight => 1, :value => 120},
  {:weight => 1, :value => 150},
  {:weight => 1, :value => 180},
  {:weight => 1, :value => 130}
]

memo = Hash.new { |h,k| h[k] = {} }

def knapsack(items, memo, i, j)
  unless memo[i][j]
    memo[i][j] = if i == 0 || j == 0
                   0
                 elsif items[i - 1][:weight] > j
                   knapsack(items, memo, i - 1, j)
                 else
                   Math.max(
                     knapsack(items, memo, i - 1, j),
                     items[i-1][:value] + knapsack(items, memo, i - 1, j - items[i-1][:weight])
                   )
                 end
    puts "#{i}-#{j}"
  end
  memo[i][j]
end

puts knapsack(items, memo, items.length, 10)