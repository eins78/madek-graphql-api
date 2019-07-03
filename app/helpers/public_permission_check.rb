class PublicPermissionCheck
  def self.for(object)
    unless object.get_metadata_and_previews
      MadekErrors::NotPublic.new(object)
    end
  end
end
