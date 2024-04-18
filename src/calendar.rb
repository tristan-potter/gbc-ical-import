#!/usr/bin/env ruby
# frozen_string_literal: true

require 'icalendar'

class Calendar
  attr_reader :tzid

  def self.with(*args, **kwargs)
    c = new(*args, **kwargs)
    yield(c)
    c
  end

  def initialize(timezone: :eastern)
    @calendar = Icalendar::Calendar.new
    @calendar.prodid = '-//Tristan Potter//NONSGML ExportToCalendar//EN'
    @calendar.version = '2.0'

    case timezone
    when :eastern
      @tzid = add_eastern_time
    else
      raise ArgumentError, 'Invalid timezone'
    end
  end

  def add_eastern_time
    eastern_time_id = 'Canada/Eastern'

    @calendar.timezone do |t|
      t.tzid = 'Canada/Eastern'

      t.daylight do |d|
        d.tzoffsetfrom = '-0500'
        d.tzoffsetto   = '-0400'
        d.tzname       = 'EDT'
        d.dtstart      = '19700308T020000'
        d.rrule        = 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU'
      end

      t.standard do |s|
        s.tzoffsetfrom = '-0400'
        s.tzoffsetto   = '-0500'
        s.tzname       = 'EST'
        s.dtstart      = '19701101T020000'
        s.rrule        = 'FREQ=YEARLY;BYMONTH=11;BYDAY=1SU'
      end
    end

    eastern_time_id
  end

  def create_event(dtstart:, dtend:, summary:, description:, location:)
    @calendar.event do |event|
      event.dtstart = wrapped_datetime(dtstart)
      event.dtend = wrapped_datetime(dtend)
      event.summary = summary
      event.description = description
      event.location = location
    end
  end

  def write_ical_file(filename)
    File.write(filename, @calendar.to_ical)
  end

  def to_ical
    @calendar.to_ical
  end

  private

  def wrapped_datetime(datetime)
    Icalendar::Values::DateTime.new(
      datetime, tzid:
    )
  end
end
