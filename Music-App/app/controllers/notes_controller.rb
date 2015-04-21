class NotesController < ApplicationController
  def create
    @note = Note.new(note_params)
    @note.author_id = current_user.id

    flash[:errors] = @note.errors.full_messages unless @note.save

    redirect_to track_url(@note.track)
  end

  def destroy

  end

  private

  def ensure_author
    @note = Note.find(params[:id])
    render text: '403 FORBIDDEN' if @note.author?(current_user)
  end

  def note_params
    params.require(:note).permit(:content, :track_id)
  end
end
