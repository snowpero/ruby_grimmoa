require 'test_helper'

class ImgPostsControllerTest < ActionController::TestCase
  setup do
    @img_post = img_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:img_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create img_post" do
    assert_difference('ImgPost.count') do
      post :create, img_post: { count_recommend: @img_post.count_recommend, count_reply: @img_post.count_reply, post_date: @img_post.post_date, post_link: @img_post.post_link, post_thumb: @img_post.post_thumb, post_title: @img_post.post_title, site_info: @img_post.site_info, user_id: @img_post.user_id }
    end

    assert_redirected_to img_post_path(assigns(:img_post))
  end

  test "should show img_post" do
    get :show, id: @img_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @img_post
    assert_response :success
  end

  test "should update img_post" do
    patch :update, id: @img_post, img_post: { count_recommend: @img_post.count_recommend, count_reply: @img_post.count_reply, post_date: @img_post.post_date, post_link: @img_post.post_link, post_thumb: @img_post.post_thumb, post_title: @img_post.post_title, site_info: @img_post.site_info, user_id: @img_post.user_id }
    assert_redirected_to img_post_path(assigns(:img_post))
  end

  test "should destroy img_post" do
    assert_difference('ImgPost.count', -1) do
      delete :destroy, id: @img_post
    end

    assert_redirected_to img_posts_path
  end
end
