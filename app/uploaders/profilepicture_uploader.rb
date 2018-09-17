class ProfilepictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end
  
  process :resize_to_limit => [500, nil]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
