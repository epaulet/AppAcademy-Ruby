class TracksController < ApplicationController
  before_action :ensure_logged_in

  def new
    @track = Track.new
    @track.album = Album.find(params[:album_id])
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      redirect_to track_url(@track)
    else
      flash[:errors] = @track.errors.full_messages
      redirect_to new_album_track_url
    end
  end

  def show
    @track = Track.find(params[:id])
  end

  def edit
    @track = Track.find(params[:id])
  end

  def update
    @track = Track.find(params[:id])

    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash[:errors] = @track.errors.full_messages
      redirect_to edit_track_url(@track)
    end
  end

  def destroy
    @track = Track.find(params[:id])

    unless @track.nil?
      @track.destroy
    end

    redirect_to album_url(@track.album)
  end

  private

  def track_params
    params.require(:track).permit(:album_id, :name, :bonus, :lyrics)
  end
end
