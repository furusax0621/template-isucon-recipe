include_cookbook 'graphviz'
include_cookbook 'gv'
include_cookbook 'pprotein'
include_cookbook 'nginx', 'pprotein'

template '/lib/systemd/system/pprotein-server.service' do
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[systemctl daemon-reload]'
end

execute 'systemctl daemon-reload' do
    action :nothing
end

service 'pprotein-server' do
    action [:enable, :start]
end
