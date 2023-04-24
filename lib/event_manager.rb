require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone(phone)
    phone.to_s.gsub!(/[^\d]/, "")
    if phone.length == 10
      phone
    elsif phone.length == 11 && phone[0] == '1'
      phone[1..-1]
    else
      "nan"
    end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
     address: zip,
     levels: 'country',
     roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
   rescue
     'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
   end
  end

  def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end

puts 'Event Manager Initialized!'

def open_csv
  CSV.open(
  'event_attendees.csv',
   headers: true,
   header_converters: :symbol
)
end

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

#contents.each do |row|
  #id = row[0]
  #name = row[:first_name]
  
  #phone = clean_phone(row[:homephone])

  #zipcode = clean_zipcode(row[:zipcode])

  #legislators = legislators_by_zipcode(zipcode)

  #form_letter = erb_template.result(binding)
  
 # save_thank_you_letter(id, form_letter)

  #puts "#{name} #{zipcode} #{phone}"
  #end

  def common_hour
    contents = open_csv
    hour_array = []
    contents.each do |row|
      reg_date = row[:regdate]
      reg_hour = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%k')
      hour_array.push(reg_hour)
  end
  most_common_hour = hour_array.reduce(Hash.new(0)) do |hash, hour|
    hash[hour] += 1
    hash
  end
  most_common_hour.max_by { |k, v| v }[0]
  end
  
  def most_common_reg_day
    contents = open_csv
    reg_day_array = []
    contents.each do |row|
      reg_date = row[:regdate]
      reg_day = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%A')
      reg_day_array.push(reg_day)
    end
    most_common_day = reg_day_array.reduce(Hash.new(0)) do |hash, day|
      hash[day] += 1
      hash
    end
    most_common_day.max_by { |k, v| v }[0]
  end


 puts "#{common_hour}:00"

 puts "#{most_common_reg_day}"