:foreach c in={"10.0.0.0/8";"172.16.0.0/12";"192.168.0.0/16"} do={ /ip firewall address-list add list=singbox-direct address=$c comment="singbox:direct-private" }
/ip route add dst-address=0.0.0.0/0 gateway=172.20.0.2 routing-table=via-singbox distance=1 check-gateway=ping comment="singbox container"
/ip route add dst-address=0.0.0.0/0 blackhole routing-table=via-singbox distance=10 comment="singbox killswitch"
/ip firewall mangle add chain=prerouting src-address=<CLIENT-IP> dst-address-list=singbox-direct action=accept passthrough=yes comment="singbox: client private bypass"
/ip firewall mangle add chain=prerouting src-address=<CLIENT-IP> dst-address-type=local action=accept passthrough=yes comment="singbox: client router bypass"
/ip firewall mangle add chain=prerouting src-address=<CLIENT-IP> connection-state=new dst-address-list=singbox action=mark-connection new-connection-mark=singbox-cm passthrough=yes comment="singbox: client selected services"
/ip firewall mangle add chain=prerouting src-address=<CLIENT-IP> connection-mark=singbox-cm action=mark-routing new-routing-mark=via-singbox passthrough=no comment="singbox: client only"
/ip firewall mangle add chain=forward action=change-mss new-mss=clamp-to-pmtu protocol=tcp tcp-flags=syn out-interface=br-singbox comment="singbox MSS clamp"
