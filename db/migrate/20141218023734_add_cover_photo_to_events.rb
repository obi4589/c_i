class AddCoverPhotoToEvents < ActiveRecord::Migration
  def change
  	add_attachment :events, :cover_photo
  end
end
