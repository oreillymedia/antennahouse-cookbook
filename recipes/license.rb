if node["antennahouse"]["license_url"]

  node["antennahouse"]["installs"].each do |install|  
    license_url = node["antennahouse"]["license_url"]
    license_local = "#{install["install_dir"]}/etc/AHFormatter.lic"
    old_license = "#{license_local}-eval"

    Chef::Log.info("Installing license from #{license_url}")

    ruby_block "Rename default old license" do
      block do
        ::File.rename(license_local, old_license)
      end
      not_if    { ::File.exists?(old_license) }
    end

    remote_file license_local do
      owner     'root'
      group     'root'
      mode      '0644'
      backup    false
      source    license_url
      not_if    { ::File.exists?(license_local) }
    end
  end

else
  Chef::Log.info("Skipping Antennahouse License installation: No license URL provided")
end