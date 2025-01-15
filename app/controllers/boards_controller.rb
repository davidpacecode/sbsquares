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
  end

  def update
    if @board.update(game_params)
      redirect_to @board
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
      @board = Board.find(params[:id]) # will eventually want .includes(:squares) when I implement them
    end

    def board_params
      params.require(:board).permit(
        :name,
        :price
        # quarter_scores_attributes: [ :id, :team_1_score, :team_2_score, :quarter ]
      )
    end
end
