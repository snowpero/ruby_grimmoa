require 'nokogiri'
require 'open-uri'

class Notice < ActiveRecord::Base
  validates :link, :uniqueness => true

  url = "http://www.clien.net/cs2/bbs/board.php?bo_table=park&page=1"

  data = Nokogiri::HTML(open(url))

  @notices = data.css('tbody tr')

  if Notice.count > 0
    Notice.delete_all
  end

  eachCount = 0
  first_post_subject = nil

  @notices.each do |notice|
    tr_class = notice['class']
    td_num = notice.css('td')[0].text
    post_subject = notice.css('td.post_subject a').text
    writer = notice.css('td.post_name span').text
    if writer.to_s.empty?
      writer = notice.css('td.post_name img')[0]['src']
    end
    date = notice.css('td')[3].text
    link = notice.css('td.post_subject a')[0]['href']

    Rails.logger.debug "==========================\n"#+notice.to_s
    Rails.logger.debug "tr_class : "+tr_class
    Rails.logger.debug "td_num : "+td_num
    Rails.logger.debug "post_subject : "+post_subject
    Rails.logger.debug "writer : "+writer
    Rails.logger.debug "date : "+date
    Rails.logger.debug "link : "+link.to_s
    Rails.logger.debug "\n"

    Notice.create(
              :title => post_subject,
              :created_on => date,
              :link => link,
              :writer => writer,
              :post_type => tr_class.to_s
    )

    if eachCount == 1
      first_post_subject = post_subject
    end

    eachCount = eachCount+1
  end

  Rails.logger.debug "**************** first post subject : " + first_post_subject

end
