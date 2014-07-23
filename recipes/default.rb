node["antennahouse"]["installs"].each do |install|

  url_file = "#{install["baseurl"]}/#{install["filename"]}"
  tmp_file = "/tmp/#{install["filename"]}"
  tmp_install_dir = "/tmp/ahtemp"
  unpacked_file = tmp_file.gsub(".gz", "")
  deb_file = unpacked_file.gsub(/AHFormatterV(\d*)_64-(.*?).x86_64.rpm/, 'ahformatterv\1-64_\2_amd64.deb')
  install_dir = install["install_dir"]
  install_shell_script = "#{install_dir}/run.sh"

  remote_file tmp_file do
    owner     'root'
    group     'root'
    mode      '0644'
    backup    false
    source    url_file
    not_if    { ::File.exists?(tmp_file) || ::File.exists?(unpacked_file) || ::File.directory?(install["install_dir"]) }
  end

  execute 'antennahouse-unpack' do
    command   "gzip -N -d /tmp/#{install["filename"]}"
    only_if   { ::File.exists?(tmp_file) }
    not_if    { ::File.exists?(unpacked_file) || ::File.directory?(install["install_dir"]) }
  end

  package "alien" do
    action [:install, :upgrade]
  end

  execute 'antennahouse-unpack-debian' do
    command "alien -k #{unpacked_file}; mv #{File.basename(deb_file)} #{deb_file}"
    not_if  { ::File.directory?(install["install_dir"]) }
  end

  execute 'dpkg-unpack' do
    # unpack in a temp dir
    command "dpkg-deb -x #{deb_file} #{tmp_install_dir}" 
    not_if  { ::File.directory?(install["install_dir"]) }
  end

  execute 'ah-move' do
    # move to the proper locale, and update the run.sh file as needed
    command "mv #{tmp_install_dir}/usr/AH* #{install_dir}" 
    not_if  { ::File.directory?(install["install_dir"]) }
  end

  execute 'update-shell-script' do
    # Update home directory in shell script
    command "perl -p -i -e \"s%\\@\\@HOME\\@\\@%#{install_dir}%g\" #{install_shell_script}"
    not_if { !::File.exists?(install_shell_script) }
  end

  ruby_block "html.css to html.css.bak" do
    block do
      filename = "#{install["install_dir"]}/etc/html.css"
      if ::File.exists?(filename)
        ::File.rename(
          filename, 
          "#{filename}.bak"
        )
      end
    end
  end

end
