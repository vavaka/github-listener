class Hook
  def initialize(payload)
    @payload = payload
    @data = GithubHook.new(payload)
  end

  def affected_files
    a = []
    @data.commits.each do |commit|
      a = (a | commit.added | commit.modified) - commit.removed
    end

    a
  end

  def affected_i18n_files
    a = []
    affected_files.each do |file_path|
      a << file_path if file_path =~ /^config\/locales\/.+\.yml$/ 
    end

    a
  end

  def save_to_tmp(file_path, raw_data)
    Tempfile.open(File.basename(file_path), "#{Rails.root}/tmp") do |f|
      f.write(raw_data)
    end
  end

  def handle
    attachments = []
    affected_i18n_files.each do |file_path|
      raw_data = Github.fetch_raw_data(:user => @data.repository.owner['name'], :repo => @data.repository.name, :branch => 'master', :path => file_path)
      save_to_tmp(file_path, raw_data)

      attachments << {:name => File.basename(file_path), :data => raw_data}
    end

    HookMailer.mail(:payload => @payload, :attachments => attachments)
  end
end
