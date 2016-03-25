class NameValidator
  def self.validate(folder_name)
    if folder_name =~ /(?!.*__.*)[a-zA-Z0-9]+_[a-zA-Z0-9_]+[a-zA-Z0-9]/
      "#{folder_name} accepted."
    else
      "fail face!"
    end
  end
end
