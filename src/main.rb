#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './course'
require_relative './parse'
require_relative './calendar'
require_relative './schedule'

FILENAME = './detailed-schedule.txt'

class GbcCalendarImporter
  class Event
    attr_reader :dt_start, :dt_end, :summary, :description, :location

    def initialize(course, schedule, occurance)
      @dt_start = occurance.dt_start
      @dt_end = occurance.dt_end
      @summary = course.summary
      @description = course.description
      @location = schedule.location
    end
  end

  def initialize(data)
    @data = data
    @parser = Parse.new(data: @data)
    @events = collect_events(@parser.courses)
  end

  def as_calendar
    Calendar.with do |calendar|
      @events.each do |event|
        calendar.create_event(
          dtstart: event.dt_start,
          dtend: event.dt_end,
          summary: event.summary,
          description: event.description,
          location: event.location
        )
      end
    end.to_ical
  end

  private

  def collect_events(courses)
    courses.map do |course|
      course.schedules.map do |schedule|
        schedule.occurances.map do |occur|
          Event.new(course, schedule, occur)
        end
      end
    end.flatten
  end

  # The current date and time in ISO 8601 format.
  def current_time
    DateTime.now.strftime('%Y-%m-%dT%H:%M:%S%:z')
  end
end
