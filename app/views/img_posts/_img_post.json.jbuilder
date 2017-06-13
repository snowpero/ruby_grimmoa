json.extract! img_post, :id, :user_id, :post_date, :post_link, :post_thumb, :post_title, :site_info, :count_recommend, :count_reply, :created_at, :updated_at
json.url img_post_url(img_post, format: :json)
