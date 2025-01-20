class BoardsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_board, only: %i[ show edit update destroy ]

  def index
    @boards = Board.all
  end

  def show
  end

  def new
    @game = Game.find(params[:game_id])
    @board = @game.boards.build
  end

  def create
    @game = Game.find(params[:game_id])
    @board = @game.boards.build(board_params)

    if @board.save
      redirect_to game_path(@game), notice: "Board was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @game = Game.find(params[:game_id])
    @board = @game.boards.find(params[:id])
  end

  def update
    @game = Game.find(params[:game_id])
    @board.update_selected_squares(params[:selected_squares], params[:board][:nickname])

    if @board.update(board_params)
      redirect_to game_path(@game)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path
  end

  private
    def set_board
      @game = Game.find(params[:game_id])
      @board = Board.includes(:squares).find(params[:id])
    end

    def board_params
      params.require(:board).permit(
        :name,
        :price,
        squares_attributes: [ :nickname ]
      )
    end
end
