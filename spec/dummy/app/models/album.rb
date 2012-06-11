class Album
  include Mongoid::Document
  include MediaMagick::Model

  embeds_many :tracks

  attachs_many :photos
  attachs_many :files, :relation => :referenced
  attachs_many :compound_name_files

  attachs_many :images do
    field :tags, type: Array
  end

  attachs_many :pictures, uploader: PictureUploader
end
