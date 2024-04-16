# frozen_string_literal: true

class Parse
  attr_reader :data, :courses

  def initialize(filename:)
    @data = parse_data(filename)
    @courses = Course.many_from_str(@data)
  end

  def parse_data(filename)
    File.read(filename)
  end
end
