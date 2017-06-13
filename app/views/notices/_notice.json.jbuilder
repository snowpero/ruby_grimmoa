json.extract! notice, :id, :title, :link, :writer, :created_on, :created_at, :updated_at
json.url notice_url(notice, format: :json)
