require 'nokogiri'
require 'open-uri'
require 'logging'
require 'zlib'
require 'uri'
require 'date'

class ImgPost < ActiveRecord::Base

  @url_ppomppu = "http://www.ppomppu.co.kr/zboard/zboard.php?id=free_picture"
  @url_todayhumor = "http://www.todayhumor.co.kr/board/list.php?table=deca"
  @url_slr = "http://www.slrclub.com/bbs/zboard.php?id=work_gallery"
  @url_popco = "http://www.popco.net/zboard/zboard.php?id=photo_gallery"

  @site_ppomppu = "http://www.ppomppu.co.kr"
  @site_todayhumor = "http://www.todayhumor.co.kr"
  @site_slr = "http://www.slrclub.com"
  @site_popco = "http://www.popco.net"

  @domain_ppomppu = "ppomppu"
  @domain_todayhumor = "todayhumor"
  @domain_slr = "slrclub"
  @domain_popco = "popco"

  def self.parse_url(url)
    Rails.logger.debug "url : " + url

    if url.include? @domain_ppomppu
      Rails.logger.debug @domain_ppomppu
      ImgPost.parse_ppomppu(url, true)
    elsif url.include? @domain_todayhumor
      Rails.logger.debug @domain_todayhumor
      ImgPost.parse_todayhumor(url, true)
    elsif url.include? @domain_slr
      Rails.logger.debug @domain_slr
      ImgPost.parse_slr(url, true)
    elsif url.include? @domain_popco
      logger.debug @domain_popco
      ImgPost.parse_popco(url, true)
    end

    ImgPost.all
  end

  def self.getImgPostsData(page = 1)
    if ImgPost.count > 0
      ImgPost.delete_all
    end

    ImgPost.parse_ppomppu(@url_ppomppu, false, page)
    ImgPost.parse_todayhumor(@url_todayhumor, false, page)
    if page.to_i == 1
      ImgPost.parse_slr(@url_slr, false)
    end
    ImgPost.parse_popco(@url_popco, false, page)

    ImgPost.all
  end

  def self.parse_ppomppu(url, isClear, page = 1)
    uri = URI.parse(url)
    uri.query = [uri.query, "page="+page.to_s].compact.join('&')
    logger.debug "URL \n" + uri.to_s
    # data = Nokogiri::HTML(open(uri))
    data = Nokogiri::HTML(open(uri), nil, 'euc-kr')
    # data.encoding = 'utf-8'

    img_datas = data.css('div.gallery_list')

    if isClear and ImgPost.count > 0
      ImgPost.delete_all
    end

    eachCount = 0

    # begin
      img_datas.each do |post|
        gallery_img = post.css('li.gallery_img')
        gallery_info = post.css('li.gallery_info')

        logger.debug gallery_info.to_s

        img_src = gallery_img.css('a img')[0]['src']
        link = gallery_img.css('a')[0]['href']
        title = gallery_info.css('span.gallery_title').text
        user_id = gallery_info.css('font.list_name').text
        post_date = gallery_info.css('span.gallery_data').text

        logger.debug "Today Date : " + Date.today.to_date.to_s

        if !post_date.include? '/'
          post_date = Date.today.to_date.to_s + " " + post_date
        end
        date_time = Time.parse(post_date)
        logger.debug "Convert : " + date_time.to_s

        post_vote = gallery_info.css('span.gallery_vote_data').text
        reply_count = gallery_info.css('span.list_comment2').text

        if !self.valid_url(link)
          link = self.add_zboard_path(link)

          link = self.add_host_prefix(@site_ppomppu, link)
        end

        if user_id.empty?
          if gallery_info.to_s.include? 'alt'
            user_id = gallery_info.css('a img')[0]['src']
          # else
          #   user_id = 'Not Support'
          end
        end

        # Rails.logger.debug "&&& img\n" + gallery_img.to_s
        Rails.logger.debug "### img_src\n" + img_src.to_s
        Rails.logger.debug "### link\n" + link

        # Rails.logger.debug "$$$ info\n" + gallery_info.to_s
        Rails.logger.debug "$$$ title\n" + title
        Rails.logger.debug "$$$ post_date\n" + post_date
        Rails.logger.debug "$$$ id\n" + user_id
        Rails.logger.debug "$$$ vote\n" + post_vote
        Rails.logger.debug "$$$ reply\n" + reply_count

        eachCount = eachCount + 1

        # t.string :user_id
        # t.string :post_date
        # t.string :post_link
        # t.string :post_thumb
        # t.string :post_title
        # t.string :site_info
        # t.integer :count_recommend
        # t.integer :count_reply

        ImgPost.create(
            :user_id => user_id,
            :post_date => post_date,
            :post_title => title,
            :post_link => link,
            :post_thumb => img_src,
            :count_reply => reply_count,
            :count_recommend => post_vote,
            :site_info => @domain_ppomppu,
            :desc_date => date_time
        )
      end
    # rescue Exception => e
    #   puts e.message
    # end
  end

  def self.parse_todayhumor(url, isClear, page = 1)
    uri = URI.parse(url)
    uri.query = [uri.query, "page="+page.to_s].compact.join('&')
    data = Nokogiri::HTML(open(uri), nil, 'utf-8')
    # data = Nokogiri::HTML(open(url), nil, 'utf-8')

    img_datas = data.css('.list_tr_deca')

    # Rails.logger.debug "data \n" + img_datas.to_s

    if isClear and ImgPost.count > 0
      ImgPost.delete_all
    end

    eachCount = 0

    img_datas.each do |post|
      title = post.css('td.subject').css('a').text
      post_num = post.css('td.no').text
      user_id = post.css('td.name').text
      post_date = post.css('td.date').text
      post_vote = post.css('td.oknok').text
      reply_count = post.css('span.list_memo_count_span').text
      if reply_count.include? '['
        reply_count = reply_count.delete('[')
      end
      if reply_count.include? ']'
        reply_count = reply_count.delete(']')
      end
      if reply_count.empty?
        reply_count = '0'
      end
      link = post.css('td.subject').css('a')[0]['href']

      if !self.valid_url(link)
        link = self.add_host_prefix(@site_todayhumor, link)
      end

      date_time = Time.parse(post_date)
      logger.debug "Convert : " + date_time.to_s

      logger.debug "Title : " + title
      logger.debug "Post Num : " + post_num
      logger.debug "ID : " + user_id
      logger.debug "Date : " + post_date
      logger.debug "Vote : " + post_vote
      logger.debug "Reply Count : " + reply_count
      logger.debug "Link : " + link

      eachCount = eachCount + 1

      ImgPost.create(
          :user_id => user_id,
          :post_date => post_date,
          :post_title => title,
          :count_recommend => post_vote,
          :post_link => link,
          :count_reply => reply_count,
          :site_info => @domain_todayhumor,
          :desc_date => date_time
      )
    end
  end

  def self.parse_slr(url, isClear, page = 1)
    data = Nokogiri::HTML(open(url))
    data.encoding = 'utf-8'

    img_datas = data.css('ul.list').css('li')

    # logger.debug "data : " + img_datas.to_s

    if isClear and ImgPost.count > 0
      ImgPost.delete_all
    end

    eachCount = 0

    img_datas.each do |post|
      title_data = post.css('div.title')
      title = title_data.css('span.sbj').text
      post_date = title_data.css('span.date').text
      user_id = title_data.css('span.name').text

      link = post.css('a')[0]['href']
      img_url = post.css('a img')[0]['src']

      if !self.valid_url(link)
        link = self.add_host_prefix(@site_slr, link)
      end

      if !post_date.include? '/'
        post_date = Date.today.to_date.to_s + ' ' + post_date
      end
      date_time = Time.parse(post_date)
      logger.debug "Convert : " + date_time.to_s

      logger.debug "title : " + title
      logger.debug "Date : " + post_date
      logger.debug "ID : " + user_id
      logger.debug "Link : " + link
      logger.debug "URL : " + img_url

      ImgPost.create(
          :post_title => title,
          :post_date => post_date,
          :user_id => user_id,
          :post_link => link,
          :post_thumb => img_url,
          :site_info => @domain_slr,
          :desc_date => date_time
      )

      eachCount += 1
    end

    logger.debug "Size : " + eachCount.to_s
  end

  def self.parse_popco(url, isClear, page = 1)
    uri = URI.parse(url)
    uri.query = [uri.query, "page="+page.to_s].compact.join('&')
    data = Nokogiri::HTML(open(uri))
    # data = Nokogiri::HTML(open(url))
    data.encoding = 'utf-8'

    # logger.debug "data : " + data.to_s

    img_datas = data.css('table td')
    xpath_datas = img_datas.xpath('//td/table')

    # logger.debug "data : " + img_datas.to_s

    if isClear and ImgPost.count > 0
      ImgPost.delete_all
    end

    eachCount = 0

    xpath_datas.each do |post|
      if post.to_s.include? 'thumb_list_title'
        # logger.debug "POST \n" + post.to_s

        img_url = post.css('a img')[0]['src']
        link = post.css('a')[0]['href']

        title = post.css('.thumb_list_title').text
        user_id = post.css('.thumb_list_name').text
        post_date = post.css('.thumb_list_eng').text
        reply_count = post.css('.list_comment2').text
        if reply_count.empty?
          reply_count = '0'
        end

        split = post_date.split("\n")
        if split.size == 6
          post_date = split[4]
        end
        if post_date.index('2') != 0
          split.each do |split_str|
            if split_str.index('2') == 0
              post_date = split_str
            end
          end
        end

        if !self.valid_url(link)
          if !link.include? 'zboard'
            link = '/zboard/' + link
          end
          link = self.add_host_prefix(@site_popco, link)
        end
        if !self.valid_url(img_url)
          if !img_url.include? 'zboard'
            img_url = '/zboard/' + img_url
          end

          img_url = self.add_host_prefix(@site_popco, img_url)
        end

        date_time = Time.parse(post_date)
        logger.debug "Convert : " + date_time.to_s

        logger.debug "Title : " + title
        logger.debug "Image Url : " + img_url
        logger.debug "Link : " + link
        logger.debug "ID : " + user_id
        logger.debug "Date : " + split[4]
        logger.debug "Reply Count : " + reply_count

        ImgPost.create(
            :user_id => user_id,
            :post_title => title,
            :post_link => link,
            :post_thumb => img_url,
            :count_reply => reply_count,
            :post_date => post_date,
            :site_info => @domain_popco,
            :desc_date => date_time
        )

        eachCount += 1
      end
    end

    logger.debug "Size : " + eachCount.to_s
  end

  def self.valid_url(url)
    uri = URI.parse(url)
    if uri.kind_of?(URI::HTTP)
      return true
    else
      return false
    end
  end

  def self.add_host_prefix(host, url)
    if url.start_with? '/'
      return host + url
    else
      return host + '/' + url
    end
  end

  def self.add_zboard_path(url)
    if !url.include? 'zboard'
      if url.start_with? '/'
        return '/zboard' + url
      else
        return '/zboard/' + url
      end
    else
      return url
    end
  end

end
