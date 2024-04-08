# frozen_string_literal: true

class Parse
  class ScheduleBlock
    def initialize(schedule_str)
      @schedule_str = schedule_str
      @schedules = match(@schedule_str, times_regex)
    end

    private

    def match(str, regex)
      str.to_enum(:scan, regex).map { Regexp.last_match }
    end

    def time_range_regex
      /\d+:\d+ (am|pm) - \d+:\d+ (am|pm)/
    end

    def day_range_regex
      /\w{3} \d{2}, \d{4} - \w{3} \d{2}, \d{4}/
    end

    def times_regex
      /^(?<type>\w+)\t(?<time>#{time_range_regex})\t(?<days>\w)\t(?<where>.+)\t(?<range>#{day_range_regex})\t(?<schedule>\w+)\t(?<instructor>.+).*$/
    end
  end

  def initialize(filename:)
    @data = parse_data(filename)
  end

  def parse_data(filename)
    File.read(filename)
  end

  def class_name
    @data.scan(class_name_regex)
  end

  def schedule_block
    match(@data, schedule_block_regex).map do |match|
      ScheduleBlock.new(match.to_s)
    end
  end

  private

  def match(str, regex)
    str.to_enum(:scan, regex).map { Regexp.last_match }
  end

  def class_name_regex
    # FABRIC ANALYSIS - FASH 1031 - 100
    /^(?<title>[A-Z ]+) - (?<code>[A-Z]{4} \d{4}) - \d{3}$/
  end

  def schedule_block_regex
    /#{class_name_regex}\n(?<details>(^\w.*$\n)*)^$/
  end

  def campus_regex
    /^Campus:\s+(?<campus>.*)$/
  end

  def crn_regex
    # CRN:	81784
    /^CRN:\s+(?<crn>\w+)$/
  end

  def instructor_regex
    # Assigned Instructor:	Rosalia Kovarsky, Rosalia Kovarsky
    /^Assigned Instructor:\s+(?<instructor>[\w\s]+)$/
  end

  def grade_mode_regex
    /^Grade Mode:\s+(?<grade_mode>.*)$/
  end

  def credits_regex
    /^Credits:\s+(?<credits>\d+\.\d+)$/
  end

  def level_regex
    /^Level:\s+(?<level>.*)$/
  end

  def status_regex
    # Status:	**Web Registered** on Mar 19, 2024
    /^Status:\s+(?<status>.+)$/
  end

  def term_regex
    # Associated Term:	Spring 2024
    /^Associated Term:\s+(?<term>(?<semester>Spring|Fall|Winter) (?<year>\d{4}))$/
  end
end

# FABRIC ANALYSIS - FASH 1031 - 100
# Associated Term:	Spring 2024
# CRN:	81784
# Status:	**Web Registered** on Mar 19, 2024
# Assigned Instructor:	Rosalia Kovarsky, Rosalia Kovarsky
# Grade Mode:	Normal
# Credits:	3.000
# Level:	Credit
# Campus:	Casa Loma
# Scheduled Meeting Times
# Type	Time	Days	Where	Date Range	Schedule Type	Instructors
# Class	12:00 pm - 2:59 pm	T	Casa Loma-160 Kendal C449	Jul 02, 2024 - Aug 16, 2024	Lecture	Rosalia Kovarsky (P)
# Class	12:00 pm - 2:59 pm	F	Casa Loma-160 Kendal C449	Jul 02, 2024 - Aug 16, 2024	Lecture	Rosalia Kovarsky (P)
