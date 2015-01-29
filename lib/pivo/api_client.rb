module ApiClient
  private

  def client
    TrackerApi::Client.new(token: token)
  end

  def token
    YAML.load(File.read("#{ENV['HOME']}/.pivo.yml"))['token']
  end
end

