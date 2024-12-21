# https://github.com/kaz/pprotein
version = '1.2.4'

directory '/usr/share/pprotein' do
    owner 'root'
    group 'root'
    mode '0755'
end

directory '/usr/share/pprotein/bin' do
    owner 'root'
    group 'root'
    mode '0755'
end

execute 'install pprotein' do
    command <<"EOS"
curl -fSL -o "/tmp/pprotein_#{version}_#{node[:os]}_amd64.tar.gz" "https://github.com/kaz/pprotein/releases/download/v#{version}/pprotein_#{version}_#{node[:os]}_amd64.tar.gz"
tar xvzf "/tmp/pprotein_#{version}_#{node[:os]}_amd64.tar.gz" -C /usr/share/pprotein/bin
EOS
    not_if "test -f /usr/share/pprotein/bin/pprotein"
end
