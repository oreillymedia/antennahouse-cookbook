name              "antennahouse"
maintainer        "Rune Skjoldborg Madsen"
maintainer_email  "rune@oreilly.com"
license           "Apache 2.0"
description       "Installs and configures Antennahouse"

version           "0.0.1"
recipe            "antennahouse", "Installs antennahouse"
recipe            "antennahouse::license", "Installs an antennahouse license into the current Antennahouse program"

%w{ ubuntu debian }.each do |os|
  supports os
end
