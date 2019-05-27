class PublicPermissionCheck
  def self.for(object)
    unless object.get_metadata_and_previews
      raise GraphQL::ExecutionError,
        "This #{object.class.name.downcase} is not public."
    end
  end
end
