class GamesController < ApplicationController

  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_game, only: %i[ show edit update destroy edit_scores update_scores ]
  before_action :require_admin, only: %i[ new create edit update destroy edit_scores update_scores ]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # ...
  def edit_scores
  end
  
  # ...
  def update_scores
    if @game.update(score_params)
  #    render partial: 'scoreboard', locals: { game: @game }
      redirect_to @game, notice: "Game was successfully updated."
    else
      render partial: 'scoreboard_form', locals: { game: @game }, status: :unprocessable_entity
    end
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_path, notice: "Game was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.expect(game: [ 
        :home_team_id,
        :away_team_id,
        :game_datetime,
        :status,
        :q1_home,
        :q1_away,
        :q2_home,
        :q2_away,
        :q3_home,
        :q3_away,
        :q4_home,
        :q4_away
      ])
    end

    # NEW method - only allows score attributes
    def score_params
      params.expect(game: [
        :q1_home, :q1_away,
        :q2_home, :q2_away,
        :q3_home, :q3_away,
        :q4_home, :q4_away,
        :status
      ])
    end
end
