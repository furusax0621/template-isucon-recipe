include_cookbook 'nginx'

directory '/var/log/nginx' do
  owner 'www-data'
  group 'adm'
  mode '777'
end

file '/var/log/nginx/access.log' do
  owner 'www-data'
  group 'adm'
  mode '777'
  action [:create, :edit]
end

template '/etc/nginx/conf.d/alp.conf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :reload, 'service[nginx]', :delay
end

service 'nginx' do
  action [:enable, :start]
end
