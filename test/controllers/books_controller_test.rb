require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @book = books(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Book.count' do
      post books_path, params: { book: { title: "Lorem ipsum", author: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Book.count' do
      delete book_path(@book)
    end
    assert_redirected_to login_url
  end
  test "should redirect destroy for wrong book" do
    log_in_as(users(:michael))
    book = books(:ants)
    assert_no_difference 'Book.count' do
      delete book_path(book)
    end
    assert_redirected_to root_url
  end

end