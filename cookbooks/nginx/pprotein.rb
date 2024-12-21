include_cookbook 'nginx'

template '/etc/nginx/conf.d/pprotein.conf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :reload, 'service[nginx]', :delay
end

service 'nginx' do
  action [:enable, :start]
end
