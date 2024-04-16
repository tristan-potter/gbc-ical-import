#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './course'
require_relative './parse'
require_relative './calendar'
require_relative './schedule'

FILENAME = './detailed-schedule.txt'

def parse_schedule(filename)
  Parse.new(filename:)
end

def with_calendar
  calendar = Calendar.new

  yield(calendar)

  calendar
end

# The current date and time in ISO 8601 format.
def current_time
  DateTime.now.strftime('%Y-%m-%dT%H:%M:%S%:z')
end

with_calendar do |calendar|
  parse_schedule(FILENAME).courses.each do |course|
    course.schedules.each do |schedule|
      schedule.occurances.each do |occur|
        calendar.create_event(
          dtstart: occur.dt_start,
          dtend: occur.dt_end,
          summary: course.summary,
          description: course.description,
          location: schedule.location
        )
      end
    end
  end
end.write_ical_file("./dist/#{current_time}.ics")
