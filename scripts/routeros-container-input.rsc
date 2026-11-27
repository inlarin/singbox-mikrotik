/ip firewall filter add chain=input action=accept in-interface=br-singbox comment="accept input from singbox container" place-before=[find where comment="defconf: drop all not coming from LAN"]
