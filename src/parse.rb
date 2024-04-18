# frozen_string_literal: true

class Parse
  attr_reader :data, :courses

  def self.parse_data(filename)
    File.read(filename)
  end

  def self.from_file(filename)
    new(data: parse_data(filename))
  end

  def initialize(data:)
    @data = data
    @courses = Course.many_from_str(@data)
  end
end
