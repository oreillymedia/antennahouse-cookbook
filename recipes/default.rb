url_file = "#{node["antennahouse"]["baseurl"]}/#{node["antennahouse"]["filename"]}"
tmp_file = "/tmp/#{node["antennahouse"]["filename"]}"
unpacked_file = tmp_file.gsub(".gz", "")

remote_file tmp_file do
  owner     'root'
  group     'root'
  mode      '0644'
  backup    false
  source    url_file
  not_if    { ::File.exists?(tmp_file) || ::File.exists?(unpacked_file) || ::File.directory?(node["antennahouse"]["install_path"]) }
end

execute 'antennahouse-unpack' do
  command   "gzip -N -d /tmp/#{node["antennahouse"]["filename"]}"
  only_if   { ::File.exists?(tmp_file) }
  not_if    { ::File.exists?(unpacked_file) || ::File.directory?(node["antennahouse"]["install_path"]) }
end

package "alien" do
  action [:install, :upgrade]
end

execute 'antennahouse-unpack' do
  command "alien -i -d -c #{unpacked_file}"
  not_if  { ::File.exists?("#{node["antennahouse"]["install_path"]}/run.sh") }
end

ruby_block "html.css to html.css.bak" do
  block do
    filename = "#{node["antennahouse"]["install_path"]}/etc/html.css"
    if ::File.exists?(filename)
      ::File.rename(
        filename, 
        "#{filename}.bak"
      )
    end
  end
end