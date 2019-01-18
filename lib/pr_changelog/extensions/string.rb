# frozen_string_literal: true

# Some useful extensions on string
class String
  def first_uppercase
    return self unless length > 2

    "#{self[0].upcase}#{self[1, length]}"
  end

  def first_lowercase
    return self unless length > 2

    "#{self[0].downcase}#{self[1, length]}"
  end
end
