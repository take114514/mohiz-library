require 'test_helper'

class BooksInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "book interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    assert_no_difference 'Book.count' do
      post books_path, params: { book: { title: "", author: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    title = "This book really ties the room together"
    author = "Hoge Taro"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Book.count', 1 do
      post books_path, params: { book: { title: title, author: author, picture: picture } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match title, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_book = @user.books.paginate(page: 1).first
    assert_difference 'Book.count', -1 do
      delete book_path(first_book)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "book sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{34} books", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 books", response.body
    other_user.books.create!({title: "A micropost", author: "A micropost"})
    get root_path
    assert_match "#{1} book", response.body
  end
end