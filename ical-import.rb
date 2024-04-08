#!/usr/bin/env ruby
# frozen_string_literal: true

require 'icalendar'
require './course'
require './parse'

def calendar
  Icalendar::Calendar.new
end

def create_ical_event
  cal = calendar
  cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
  cal.version = '2.0'

  yield(cal.event)

  cal.to_ical
end

def vcs
  cal = calendar
  cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
  cal.version = '1.0'

  block.call(cal.event)

  cal.to_ical
end

# Create a course
course = Course.new(
  start_at: Time.new(2021, 9, 1, 9, 0, 0),
  end_at: Time.new(2021, 9, 1, 10, 0, 0),
  title: 'Introduction to Foo',
  professor: 'Dr. Foo',
  location: 'Room 101',
  time_zone: 'America/New_York'
)

# Create an ICS file for the course
event = create_ical_event do |e|
  e.dtstart     = Icalendar::Values::DateTime.new(course.start_at, tzid: course.time_zone)
  e.dtend       = Icalendar::Values::DateTime.new(course.end_at, tzid: course.time_zone)
  e.summary     = course.title
  e.description = "Professor: #{course.professor}"
  e.location    = course.location
end

parse = Parse.new(filename: './detailed-schedule.txt')
puts parse.schedule_block[0].times
