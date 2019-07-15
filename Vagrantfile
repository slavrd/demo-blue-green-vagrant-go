Vagrant.configure("2") do |config|
  config.vm.box = "slavrd/nginx64"

  # for blue/green deployment demo
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8010, host: 8010

  # port used by the nginx load balancer
  config.vm.network "forwarded_port", guest: 80, host: 8080
  
  # basic machine configuration
  if ENV['skip_go'] == nil then
    config.vm.provision "shell", path: "ops/scripts/install-golang.sh", args: ["1.12.7", "linux", "amd64"]
  end

  # deploy blue application versoin and start it
  config.vm.provision "shell", path: "ops/scripts/deploy-apps.sh", run: "always", args: ["v0.1.0", "/opt/blue/", "8000"]

  # direct traffic on nginx to the "blue" application (port 8000)
  config.vm.provision "shell", inline: "pushd /vagrant/ops/scripts; ./switch-nginx-traffic.sh blue; popd"

end
