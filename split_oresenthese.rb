#@param {String} input

# @return {Integer[]}

def diff_ways_to_compute(input)
    opers = []
    numbers = []
    numTemp = ""
    input.chars.each {| char| 
      if numeric?(char) 
        numTemp += char
      else
        numbers.push(numTemp.to_i)
        opers.push(char)
        numTemp = ""
      end
    }
    numbers.push(numTemp.to_i)
    puts numbers
    puts opers
    result = dfs(numbers, opers)
    result.sort
end

def dfs(str, opers) # 0 1, +
    result = []
    if str.length() <= 1
      return result.push(str[0])
    end
    len = opers.length()
    for i in 0..len
      puts "index: #{i}"
      left = dfs(str[0..i], opers[0..i])
      right = dfs(str[(i+1)..-1], opers[(i+1)..-1])
      puts left
      puts right
      left.each { |leftResult|
        right.each { |rightResult|
          res = doOpers(leftResult, rightResult, opers[i]) 
          result.push(res)
        }
      }
    end
    return result
end

def doOpers(i, j, char)
    if char == "*"
      return i*j
    elsif char =="+"
      return i+j
    else
      return i-j
    end
end

def numeric?(lookAhead)
  lookAhead =~ /[0-9]/
end

puts diff_ways_to_compute("0+1")
