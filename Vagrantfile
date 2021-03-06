# TODO: add nginx container --
# TODO: static ips for countainers --

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

    # generate .bash_aliases based on enabled dockers
    text = ""
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            if container[0] == "apachePhpNode" || container[0] == "node"
                text += "alias enter-%s=\"docker exec -t -i %s sudo -iu %s\"\n" % [container[0], container[0], container[1]["runUserName"]]
            else
                text += "alias enter-%s=\"docker exec -t -i %s /bin/bash\"\n" % [container[0], container[0]]
            end
        end
    end
    File.open("#{File.dirname(__FILE__)}/.bash_aliases", "w").puts(text)
    createBashAliasesCmd = "cp /vagrant/.bash_aliases /home/vagrant/.bash_aliases"
    config.vm.provision "createBashAliases", type: "shell", inline: createBashAliasesCmd, run: "once"

    # generate apache site.conf
    if serverConfig["containers"]["apachePhpNode"]["enabled"]
        text = File.open("#{File.dirname(__FILE__)}/dockerfiles/apache_php_node/site.conf.template", "r").read
        placeholders = text.scan(/(?:%).+?(?:%)/).flatten.uniq
        placeholders.each do |placeholder|
            replacement = placeholder.gsub("%", "")
            replacement = replacement.gsub(".", "\"][\"")
            replacement = "serverConfig[\"#{replacement}\"]"
            replacement = eval(replacement)
            replacement = "#{replacement}"
            text.gsub!(placeholder, replacement)
        end
        File.open("#{File.dirname(__FILE__)}/dockerfiles/apache_php_node/site.conf", "w").puts(text)
    end

    # generating dockerfiles from templates
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            text = File.open("#{File.dirname(__FILE__)}/#{container[1]["dockerfilePath"]}/Dockerfile.template", "r").read
            placeholders = text.scan(/(?:%).+?(?:%)/).flatten.uniq
            placeholders.each do |placeholder|
                replacement = placeholder.gsub("%", "")
                replacement = replacement.gsub(".", "\"][\"")
                replacement = "serverConfig[\"#{replacement}\"]"
                replacement = eval(replacement)
                replacement = "#{replacement}"
                text.gsub!(placeholder, replacement)
            end

            exposeString = ""
            container[1]["ports"].each do |portData|
                exposeString += "EXPOSE %d\n" % [portData[1]["container"]]
            end
            text.gsub!("<<ports>>", exposeString)

            File.open("#{File.dirname(__FILE__)}/#{container[1]["dockerfilePath"]}/Dockerfile", "w").puts(text)
        end
    end

    # building dockerfiles
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            config.vm.provision "docker" do |d|
                d.build_image "/vagrant/#{container[1]["dockerfilePath"]}", args: "-t \"%s\"" % [container[1]["imageName"]]
            end
        end
    end

    # running dockerfiles
    serverConfig["containers"].each do |container|
        if container[1]["enabled"]
            config.vm.provision "docker" do |d|
                runArgs = " --name='#{container[0]}' "
                container[1]["ports"].each do |portData|
                    runArgs += " -p %d:%d " % [portData[1]["host"], portData[1]["container"]]
                end
                runArgs += container[1]["runArgs"]
                d.run container[1]["imageName"], args: runArgs, auto_assign_name: false, daemonize: true
            end
        end
    end
end
