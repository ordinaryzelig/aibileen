class Event

  attr_reader :start
  attr_reader :stop

  def initialize(atts = {})
    atts.each do |att, val|
      send "#{att}=", val
    end
  end

  def hours
    @hours ||= ((stop - start) * 24).to_f.round(2)
  end

  def to_s
    "#{start.strftime '%a'} #{start.strftime '%m-%d'}: #{hours}"
  end

private

  attr_writer :start
  attr_writer :stop

  class << self

    def parse_events(event_summary_text)
      dates_and_times = event_summary_text.select { |t| t =~ /^Time|Date/ }
      dates_and_times.each_slice(2).map do |date, time|
        dates = date.scan /\d+\/\d+\/\d+/
        times = time.split ' to '
        parse(dates, times)
      end
    end

    def parse(dates_string, times_string)
      start, stop = 2.times.map do |idx|
        month, day, year = dates_string[idx].scan(/\d+/)
        year = Integer(year) + 2000
        # Encoding issue between numbers and AM/PM.
        /(?<hour>\d+):(?<minute>\d{2}):(?<sec>\d{2})/ =~ times_string[idx]
        hour = Integer(hour.sub(/^0/, ''))
        DateTime.new Integer(year), Integer(month), Integer(day), Integer(hour), Integer(minute)
      end
      Event.new(
        :start => start,
        :stop  => stop,
      )
    end

  end

end
