require "geminabox"
require "rack/rsync"

if ENV["GEMINABOX_PRIMARY"] == ENV["GEMINABOX_MYADDRESS"]
  src = "/opt/gem_server/data/"
  dst = "#{ENV['GEMINABOX_SECONDARY']}:/opt/gem_server/data/"

  use Rack::Rsync, src, dst, "-a", "--delete" do |env|
    env["REQUEST_METHOD"] == "POST" || env["REQUEST_METHOD"] == "DELETE"
  end
end

Geminabox.data = "/opt/gem_server/data"
Geminabox.rubygems_proxy = true
run Geminabox
