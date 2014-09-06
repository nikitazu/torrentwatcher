class AnimesController < ApplicationController
  before_action :set_anime, only: [:show, :edit, :update, :destroy, :restore, :up]
  before_filter :authenticate_user!

  # GET /animes
  # GET /animes.json
  def index
    @tags = Tag.all
    if params[:deleted]
      @animes = current_user.animes.deleted
    else
      @animes = current_user.animes.current
    end
  end

  # GET /animes/1
  # GET /animes/1.json
  def show
    @torrents = @anime.lookup_torrents
    render layout: false
  end

  # GET /animes/new
  def new
    @anime = Anime.new
    @anime.user = current_user
  end

  # GET /animes/1/edit
  def edit
  end

  # POST /animes
  # POST /animes.json
  def create
    @anime = Anime.new(anime_params)
    @anime.user = current_user
    respond_to do |format|
      if @anime.save
        format.html { redirect_to animes_url, notice: 'Anime was successfully created.' }
        format.json { render :show, status: :created, location: @anime }
      else
        format.html { render :new }
        format.json { render json: @anime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animes/1
  # PATCH/PUT /animes/1.json
  def update
    respond_to do |format|
      @anime.user = current_user
      if @anime.update(anime_params)
        format.html { redirect_to animes_url, notice: 'Anime was successfully updated.' }
        format.json { render :show, status: :ok, location: @anime }
      else
        format.html { render :edit }
        format.json { render json: @anime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animes/1
  # DELETE /animes/1.json
  def destroy
    @anime.update is_deleted: true
    respond_to do |format|
      format.html { redirect_to animes_url, notice: 'Anime was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST /animes/1/restore
  def restore
    @anime.update is_deleted: false
    respond_to do |format|
      format.html { redirect_to animes_url, notice: 'Anime was successfully restored.' }
      format.json { head :no_content }
    end
  end
  
  # POST /animes/1/up
  def up
    @anime.update progress: @anime.progress+1
    respond_to do |format|
      format.html { redirect_to animes_url, notice: 'Anime progress was successfully upped.' }
      format.json { render json: @anime.progress, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anime
      @anime = Anime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def anime_params
      params.require(:anime).permit(:title, :status, :score, :episodes, :progress)
    end
end
