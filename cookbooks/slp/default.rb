# https://github.com/tkuchiki/slp
# https://github.com/tkuchiki/slp/blob/main/README.ja.md
github_binary 'slp' do
    repository 'tkuchiki/slp'
    version 'v0.2.1'
    archive "slp_#{node[:os]}_amd64.zip"
end
