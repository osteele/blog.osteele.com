Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu"
  config.vm.hostname = "blog-dev"
  config.vm.provision :shell, :path => "config/bootstrap.sh"
  config.vm.network :forwarded_port, host: 8082, guest: 80
end
