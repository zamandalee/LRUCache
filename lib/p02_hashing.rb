class Fixnum
  # Fixnum#hash already implemented
end

class Array
  def hash
    alphabet = ('a'..'z').to_a
    sum = 0

    each_with_index do |el, idx|
      sum += el * idx if el.is_a?(Integer)
      sum += alphabet.find_index(el.downcase) * idx if el.is_a?(String)
    end

    sum.hash
  end
end

class String
  def hash
    alphabet = ('a'..'z').to_a
    sum = 0

    split("").each_with_index do |letter, idx|
      sum += alphabet.find_index(letter.downcase) * idx
    end

    sum.hash
  end
end

class Hash
  def hash
    keys.sort.map(&:to_s).hash
  end
end
