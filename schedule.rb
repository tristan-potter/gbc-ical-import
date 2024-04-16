# frozen_string_literal: true

# Represents a class schedule block
class Schedule
  TIME_RANGE_REGEX = /(?<start_time>\d+:\d+ (am|pm)) - (?<end_time>\d+:\d+ (am|pm))/
  DAY_RANGE_REGEX = /(?<start_date>\w{3} \d{2}, \d{4}) - (?<end_date>\w{3} \d{2}, \d{4})/
  SCHEDULES_REGEX = /^(?<type>\w+)\t(?<time>#{TIME_RANGE_REGEX})\t(?<days>\w*)\t(?<location>.+)\t(?<range>#{DAY_RANGE_REGEX})\t(?<schedule>\w+)\t(?<instructor>.+).*$/

  class << self
    def many_from_course_str(str)
      str.to_enum(:scan, SCHEDULES_REGEX).map
         .map { Regexp.last_match }
         .map { |match| from_match(match) }
    end

    def from_str(str)
      match = str.match(SCHEDULES_REGEX)
      from_match(match)
    end

    def from_match(match)
      new(
        start_time: match[:start_time],
        end_time: match[:end_time],
        days: match[:days],
        location: match[:location],
        start_date: match[:start_date],
        end_date: match[:end_date],
        instructor: match[:instructor]
      )
    end
  end

  class Occurance
    attr_reader :dt_start, :dt_end

    def initialize(date:, start_time:, end_time:)
      @dt_start = time_on_date(date, start_time)
      @dt_end = time_on_date(date, end_time)
    end

    def time_on_date(date, time)
      DateTime.new(
        date.year, date.month, date.day,
        time.hour, time.min, 0
      )
    end
  end

  attr_reader :start_date, :end_date, :instructor, :location

  def initialize(start_time:, end_time:, days:, location:, start_date:, end_date:, instructor:)
    @start_time = Time.strptime(start_time, time_fmt)
    @end_time = Time.strptime(end_time, time_fmt)

    @start_date = Date.strptime(start_date, date_fmt)
    @end_date = Date.strptime(end_date, date_fmt)

    @days_str = days

    @location = location
    @instructor = instructor
  end

  # Returns all of the event dates from the start date to the end date, on the days that the event is scheduled.
  def event_dates
    (start_date..end_date).to_a.select do |date|
      days.include?(date.strftime('%A'))
    end
  end

  def occurances
    event_dates.map do |date|
      Occurance.new(
        date:,
        start_time: @start_time,
        end_time: @end_time
      )
    end
  end

  def days
    @days ||= @days_str.split('').map { |day| parse_day(day) }
  end

  def start_time(date)
    DateTime.new(
      date.year, date.month, date.day, @start_time.hour, @start_time.min, 0
    )
  end

  def end_time(date)
    DateTime.new(
      date.year, date.month, date.day, @end_time.hour, @end_time.min, 0
    )
  end

  def to_s
    "#{@start_time} to #{@end_time} on #{parse_day(days)} at #{location} from #{start_date} till #{end_date} with #{instructor}"
  end

  private

  def date_fmt
    '%b %d, %Y'
  end

  def time_fmt
    '%I:%M %p'
  end

  def datetime_fmt
    "#{date_fmt} #{time_fmt}"
  end

  def parse_day(day_char)
    case day_char
    when 'M'
      'Monday'
    when 'T'
      'Tuesday'
    when 'W'
      'Wednesday'
    when 'R'
      'Thursday'
    when 'F'
      'Friday'
    when 'S'
      'Saturday'
    when 'U'
      'Sunday'
    else
      'Unknown'
    end
  end
end
