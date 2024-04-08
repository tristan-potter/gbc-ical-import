# frozen_srting_literal: true

# A class that represents a class at a university or college
# with a start and end time, a title, professor and location
class Course
  attr_accessor :start_at, :end_at, :title, :professor, :location, :time_zone

  def initialize(start_at:, end_at:, title:, professor:, location:, time_zone:)
    @start_at = start_at
    @end_at = end_at
    @title = title
    @professor = professor
    @location = location
    @time_zone = time_zone
  end
end
