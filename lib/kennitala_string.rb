# frozen_string_literal: true

# Monkey patch for the String class
class String
  # Converts a String to a Kennitala object
  #
  # @return [Kennitala]
  def to_kt
    Kennitala.new(self)
  end

  # Checks if the String is valid for initializing a Kennitala object
  #
  # This is useful if you want to deal with conditionals before catching errors.
  #
  # @return Boolean
  def kt?
    true if Kennitala.new(self)
  rescue ArgumentError, TypeError
    false
  end
end
