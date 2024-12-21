directory '/var/log/mysql' do
  owner 'mysql'
  group 'adm'
  mode '777'
end

file '/var/log/mysql/mysql-slow.log' do
  owner 'mysql'
  group 'adm'
  mode '777'
  action [:create, :edit]
end

template '/etc/mysql/mysql.conf.d/slow-query-log.cnf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, 'service[mysql]', :delay
end

service 'mysql'
