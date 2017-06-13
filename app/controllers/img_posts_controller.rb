class ImgPostsController < ApplicationController
  before_action :set_img_post, only: [:show, :edit, :update, :destroy]

  # GET /img_posts
  # GET /img_posts.json
  def index
    if params[:parse_url].nil?
      if !params[:allData].nil? and params[:allData]
        page = 1
        if !params[:page].nil?
          page = params[:page]
        end

        @img_posts = ImgPost.getImgPostsData(page).order(desc_date: :desc)
      elsif
        @img_posts = ImgPost.all
      end
    else
      @img_posts = ImgPost.parse_url(params[:parse_url])
    end
  end

  # GET /img_posts/1
  # GET /img_posts/1.json
  def show
  end

  # GET /img_posts/new
  def new
    @img_post = ImgPost.new
  end

  # GET /img_posts/1/edit
  def edit
  end

  # POST /img_posts
  # POST /img_posts.json
  def create
    @img_post = ImgPost.new(img_post_params)

    respond_to do |format|
      if @img_post.save
        format.html { redirect_to @img_post, notice: 'Img post was successfully created.' }
        format.json { render :show, status: :created, location: @img_post }
      else
        format.html { render :new }
        format.json { render json: @img_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /img_posts/1
  # PATCH/PUT /img_posts/1.json
  def update
    respond_to do |format|
      if @img_post.update(img_post_params)
        format.html { redirect_to @img_post, notice: 'Img post was successfully updated.' }
        format.json { render :show, status: :ok, location: @img_post }
      else
        format.html { render :edit }
        format.json { render json: @img_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /img_posts/1
  # DELETE /img_posts/1.json
  def destroy
    @img_post.destroy
    respond_to do |format|
      format.html { redirect_to img_posts_url, notice: 'Img post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_img_post
    @img_post = ImgPost.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def img_post_params
    params.require(:img_post).permit(:user_id, :post_date, :post_link, :post_thumb, :post_title, :site_info, :count_recommend, :count_reply)
  end
end
