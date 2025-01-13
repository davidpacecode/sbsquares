class GamesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_game, only: %i[ show edit update destroy ]

  def index
    @games = Game.all
  end

  def show
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to @game
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @game.update(game_params)
      redirect_to @game
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path
  end

  private
    def set_game
      @game = Game.includes(:quarter_scores).find(params[:id])
    end

    def game_params
      #      params.expect(game: [ :team_1, :team_2, :game_date ], quarter_scores_attributes: [ :team_1_score, :team_2_score, :quarter ])
      params.require(:game).permit(
        :team_1,
        :team_2,
        :game_date,
        quarter_scores_attributes: [ :id, :team_1_score, :team_2_score, :quarter ]
      )
    end
end
