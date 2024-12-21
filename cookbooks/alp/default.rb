# https://github.com/tkuchiki/alp
# https://github.com/tkuchiki/alp/blob/main/README.ja.md
github_binary 'alp' do
    repository 'tkuchiki/alp'
    version 'v1.0.21'
    archive "alp_#{node[:os]}_amd64.zip"
end
