require 'bundler/setup'
Bundler.require
require 'date'
require_relative 'event'

text = File.readlines ARGV[0]
prompt = !ENV['USE_PROMPT'].nil?
events = Event.parse_events(text)

selected =
  if prompt
    prompt = TTY::Prompt.new
    choices = {'All' => :all}
    choices.merge!(
      events.each_with_object({}) do |event, hash|
        display = event.start.strftime '%A %m-%d'
        hash[display] = event
      end
    )
    prompt.multi_select 'Which days?', choices
  else
    events
  end

selected_events =
  if selected.include?(:all)
    events
  else
    selected
  end
puts selected_events
puts "Total: #{selected_events.map(&:hours).sum}"
