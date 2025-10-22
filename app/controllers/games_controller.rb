class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy claim_squares randomize_numbers ]

  allow_unauthenticated_access only: %i[ index ]

  # GET /games or /games.json
  def index
    upcoming = Game.where("game_date >= ?", Time.current).order(:game_date)
    past = Game.where("game_date < ?", Time.current).order(game_date: :desc)
    @games = upcoming + past
  end

  # GET /games/1 or /games/1.json
  def show
    @user = Current.user
    @current_total_cost = @game.squares.where(user_id: @user.id).count * @game.square_price
    @q1_numbers = @game.winning_numbers 1
    @q2_numbers = @game.winning_numbers 2
    @q3_numbers = @game.winning_numbers 3
    @q4_numbers = @game.winning_numbers 4
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
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

  def claim_squares
    square_ids = params[:square_ids] || []

    if square_ids.empty?
      redirect_to game, alert: "Please select at least one square"
    end

    claimed_count = 0
    already_claimed = []

    square_ids.each do |square_id|
      square = @game.squares.find(square_id)
      if square.user_id.present?
        already_claimed << "#{square.row},#{square.column}"
      elsif square.update(user: Current.user)
        claimed_count += 1
      end
    end

    if claimed_count > 0 && already_claimed.empty?
      redirect_to @game, notice: "Successfully claimed #{claimed_count} squares"
    elsif claimed_count > 0 && already_claimed.any?
      redirect_to @game, notice: "Successfully claimed #{claimed_count} squares. Some were already taken..."
    else
      redirect_to @game, alert: "Update failed - all of the squares were already claimed..."
    end
  end

  def randomize_numbers
    if @game.randomize_numbers!
      redirect_to @game, notice: "Look at those gorgeous randomized numbers!"
    else
      redirect_to @game, alert: "Randomization failed. Looks like I picked the wrong week to quit sniffing glue..."
    end
  end

  def edit_scores
    @game = Game.find(params[:id])
  end

  def update_scores
    @game = Game.find(params[:id])

    10.times do
      Rails.logger.debug "FUCK YOU!!!"
    end
    Rails.logger.debug "Params: #{params.inspect}"
    Rails.logger.debug "Scores params: #{params[:scores].inspect}"
    10.times do
      Rails.logger.debug "FUCK YOU!!!"
    end

    if params[:game] && params[:game][:scores]
      params[:game][:scores].each do |_key, score_params|
        score = @game.scores.find(score_params[:id])
        score.update(
         team_1_score: score_params[:team_1_score],
         team_2_score: score_params[:team_2_score]
      )
    end

      redirect_to @game, notice: "Scores updated successfully!"
    else
      render :edit_scores, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.expect(game: [ :team_1, :team_2, :game_date, :team_1_logo, :team_2_logo, :team_1_numbers, :team_2_numbers, :square_price, :team_1_score, :team_2_score, :scores ])
    end
end
