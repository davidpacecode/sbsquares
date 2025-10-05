require "application_system_test_case"

class SquaresTest < ApplicationSystemTestCase
  setup do
    @square = squares(:one)
  end

  test "visiting the index" do
    visit squares_url
    assert_selector "h1", text: "Squares"
  end

  test "should create square" do
    visit squares_url
    click_on "New square"

    fill_in "Column", with: @square.column
    fill_in "Game", with: @square.game_id
    fill_in "Row", with: @square.row
    fill_in "User", with: @square.user_id
    click_on "Create Square"

    assert_text "Square was successfully created"
    click_on "Back"
  end

  test "should update Square" do
    visit square_url(@square)
    click_on "Edit this square", match: :first

    fill_in "Column", with: @square.column
    fill_in "Game", with: @square.game_id
    fill_in "Row", with: @square.row
    fill_in "User", with: @square.user_id
    click_on "Update Square"

    assert_text "Square was successfully updated"
    click_on "Back"
  end

  test "should destroy Square" do
    visit square_url(@square)
    click_on "Destroy this square", match: :first

    assert_text "Square was successfully destroyed"
  end
end
