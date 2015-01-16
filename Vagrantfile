# TODO: set timezone in docker containers ++
# TODO: docker ports php -> 3306, 11211 ++
# TODO: add nginx container
# TODO: add mysql-proxy container
# TODO: setup php.ini ++
# TODO: install php-memcached ++
# TODO: setup apache ++
# TODO: static ips for countainers --
# TODO: put apache logs to project dir ++
# TODO: put mysql logs to project dir ++
# TODO: env for apache container ++
# TODO: mount for apache container ++
# TODO: access host -> vagrant -> docker ++

require 'json'
require 'fileutils'

serverConfig = JSON.parse(File.read(File.expand_path "./vagrant-config.json"))

Vagrant.configure(2) do |config|
    # docker-friendly ubuntu
    config.vm.box = "phusion/ubuntu-14.04-amd64"

    # networking
    config.vm.network "private_network", ip: serverConfig["vagrantIp"]

    # set timezone
    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
        setTimeCmd = "echo '"+ serverConfig["timezone"] +"' | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
        config.vm.provision "setTime", type: "shell", inline: setTimeCmd, run: "once"
    end

    # auto-upgrade system on every start
    updateCmd = "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade"
    config.vm.provision "update", type: "shell", inline: updateCmd, run: "always"

    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
        # install docker
        installDockerCmd = "wget -q -O - https://get.docker.io/gpg | apt-key add - && "\
            "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && "\
            "apt-get update -qq && "\
            "apt-get install --assume-yes --force-yes lxc-docker && "\
            "usermod -a -G docker vagrant"
        config.vm.provision "installDocker", type: "shell", inline: installDockerCmd, run: "once"

        # install other
        installOtherCmd = "apt-get install --assume-yes mc bash-completion && "\
            "echo \"SELECTED_EDITOR=/usr/bin/mcedit\" > /home/vagrant/.selected_editor"
        config.vm.provision "installOther", type: "shell", inline: installOtherCmd, run: "once"
    end

    # building dockerfiles
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            config.vm.provision "docker" do |d|
                d.build_image container[1]["dockerfilePath"], args: "-t \"%s\"" % [container[1]["imageName"]]
            end
        end
    end

    # running dockerfiles
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            config.vm.provision "docker" do |d|
                runArgs = " --name='%s' -p %d:%d -e TIMEZONE='%s' -e VAGRANT_IP='%s' -e DEVELOPER_IP='%s' " % [container[0], container[1]["hostPort"], container[1]["containerPort"], serverConfig["timezone"], serverConfig["vagrantIp"], serverConfig["developerIp"]]
                if container[0] == "apachePhpNode"
                    runArgs += container[1]["runArgs"] % [container[1]["runUserUid"], container[1]["runUserGid"], container[1]["runUserName"]]
                else
                    runArgs += container[1]["runArgs"]
                end
                d.run container[1]["imageName"], args: runArgs, auto_assign_name: false, daemonize: true
            end
        end
    end
end
