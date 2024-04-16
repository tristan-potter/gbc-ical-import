#!/usr/bin/env ruby
# frozen_string_literal: true

require 'icalendar'

class Calendar
  attr_reader :tzid

  def initialize(type: :icalendar, timezone: :eastern)
    @calendar = Icalendar::Calendar.new

    case type
    when :icalendar
      add_icalendar
    when :outlook
      add_outlook
    else
      raise ArgumentError, 'Invalid calendar type'
    end

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

  def add_icalendar
    @calendar.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
    @calendar.version = '2.0'
  end

  def add_outlook
    @calendar.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
    @calendar.version = '1.0'
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

  private

  def wrapped_datetime(datetime)
    Icalendar::Values::DateTime.new(
      datetime, tzid:
    )
  end
end
