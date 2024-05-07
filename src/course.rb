# frozen_string_literal: true

# A class that represents a block of courses
# given a schedule string.
class Course
  FULL_REGEX = /(?<full>^([\w& ]+ - [A-Z]{4} \d{4} - \d{3})$\n((^\w.*$\n)*)^$)/
  TITLE_REGEX = /^(?<title>[\w& ]+) - (?<code>[A-Z]{4} \d{4}) - \d{3}$/
  TIME_RANGE_REGEX = /(?<start_time>\d+:\d+ (am|pm)) - (?<end_time>\d+:\d+ (am|pm))/
  DATE_RANGE_REGEX = /(?<start_date>\w{3} \d{2}, \d{4}) - (?<end_date>\w{3} \d{2}, \d{4})/
  SCHEDULE_REGEX = /^(?<type>\w+)\t(?<time>#{TIME_RANGE_REGEX})\t(?<days>\w)\t(?<location>.+)\t(?<range>#{DATE_RANGE_REGEX})\t(?<schedule>\w+)\t(?<instructor>.+).*$/
  CAMPUS_REGEX = /^Campus:\s+(?<campus>.*)$/
  CRN_REGEX = /^CRN:\s+(?<crn>\w+)$/
  INSTRUCTOR_REGEX = /^Assigned Instructor:\s+(?<instructor>.+)$/
  GRADE_MODE_REGEX = /^Grade Mode:\s+(?<grade_mode>.*)$/
  CREDITS_REGEX = /^Credits:\s+(?<credits>\d+\.\d+)$/
  LEVEL_REGEX = /^Level:\s+(?<level>.*)$/
  STATUS_REGEX = /^Status:\s+(?<status>.+)$/
  TERM_REGEX = /^Associated Term:\s+(?<term>(?<semester>Spring|Fall|Winter) (?<year>\d{4}))$/

  class << self
    def many_from_str(str)
      str.scan(FULL_REGEX).map do |match|
        new(match.join("\n"))
      end
    end
  end

  attr_reader :course_str, :schedules, :title, :course_code, :campus, :crn, :grade_mode, :credits, :level, :status

  def initialize(course_str)
    @course_str = course_str
    @schedules = Schedule.many_from_course_str(@course_str)

    @title = @course_str.match(TITLE_REGEX)[:title]
    @course_code = @course_str.match(TITLE_REGEX)[:code]

    @campus = @course_str.match(CAMPUS_REGEX)[:campus]
    @crn = @course_str.match(CRN_REGEX)[:crn]
    @grade_mode = @course_str.match(GRADE_MODE_REGEX)[:grade_mode]
    @credits = @course_str.match(CREDITS_REGEX)[:credits]
    @level = @course_str.match(LEVEL_REGEX)[:level]
    @status = @course_str.match(STATUS_REGEX)[:status]
  end

  def instructor
    return unless (m = @course_str.match(INSTRUCTOR_REGEX))

    m[:instructor]
  end

  def summary
    "[#{course_code}] #{title}"
  end

  def description
    course_str
    <<~DESC
      Assigned Instructor: #{instructor}
      Grade Mode: #{grade_mode}
      Credits: #{credits}
      Campus: #{campus}
      Status: #{status}
      CRN: #{crn}
    DESC
  end
end
