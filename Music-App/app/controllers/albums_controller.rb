class AlbumsController < ApplicationController
  before_action :ensure_logged_in

  def new
    @album = Album.new
    @album.band = Band.find(params[:band_id])
  end

  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to album_url(@album)
    else
      flash[:errors] = @album.errors.full_messages
      redirect_to new_band_album_url(album_params[:band_id])
    end
  end

  def show
    @album = Album.find(params[:id])
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])

    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      flash[:errors] = @album.errors.full_messages
      redirect_to edit_album_url(@album)
    end
  end

  def destroy
    @album = Album.find(params[:id])

    unless @album.nil?
      @album.destroy
    end

    redirect_to band_url(@album.band)
  end

  private

  def album_params
    params.require(:album).permit(:title, :live, :band_id)
  end
end
