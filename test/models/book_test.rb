require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @book = @user.books.build(title: "PIXAR <ピクサー> 世界一のアニメーション企業の今まで語られなかったお金の話", author: "ローレンス・レビー", user_id: @user.id)
  end

  test "should be valid" do
    assert @book.valid?
  end

  test "user id should be present" do
    @book.user_id = nil
    assert_not @book.valid?
  end

  test "title should be present" do
    @book.title = "   "
    assert_not @book.valid?
  end

  test "title should be at most 140 characters" do
    @book.title = "a" * 141
    assert_not @book.valid?
  end

  test "author should be present" do
    @book.author = "   "
    assert_not @book.valid?
  end

  test "author should be at most 140 characters" do
    @book.author = "a" * 141
    assert_not @book.valid?
  end
end
