include_cookbook 'pprotein'

template '/lib/systemd/system/pprotein-agent.service' do
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[systemctl daemon-reload]'
end

execute 'systemctl daemon-reload' do
    action :nothing
end

service 'pprotein-agent' do
    action [:disable, :stop]
end
