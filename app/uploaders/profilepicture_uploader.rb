class ProfilepictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  # storage :fog
  process :resize_to_limit => [1080, nil]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
